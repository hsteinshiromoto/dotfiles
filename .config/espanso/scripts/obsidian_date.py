#!/usr/bin/env python3
"""Resolve a relative date spec to an Obsidian periodic-note name.

The espanso matches in ``.config/espanso/match/obsidian.yml`` call this with one
spec and wrap the single line of output in a wikilink.

The arithmetic lives here rather than in ten inline ``date`` calls because the
flags do not travel: ``date -v`` is BSD only and ``date -d`` is GNU only, while
this repository stows to both macOS and Linux. Stdlib only, and no syntax newer
than Python 3.9, because the interpreter on the macOS host is 3.9.6.

Note formats follow the two vaults and ``~/.config/nvim/lua/plugins/obsidian.lua``:
daily ``YYYY-MM-DD``, weekly ``YYYY-Www`` on the ISO week-year, monthly
``YYYY-MM``, quarterly ``YYYY-Qn``, yearly ``YYYY``.

Examples:
    $ python3 obsidian_date.py today
    2026-10-04
    $ python3 obsidian_date.py next:mon
    2026-10-05
"""

import sys
from datetime import date, timedelta

WEEKDAYS = ("mon", "tue", "wed", "thu", "fri", "sat", "sun")

RELATIVE_DAYS = {"today": 0, "yesterday": -1, "tomorrow": 1}

USAGE = """usage: obsidian_date.py <spec>

specs:
  today | yesterday | tomorrow
  next:<mon|tue|wed|thu|fri|sat|sun>
  last:<mon|tue|wed|thu|fri|sat|sun>
  week[+N|-N] | month[+N|-N] | quarter[+N|-N] | year[+N|-N]
"""


def iso_week(day):
    """Format a date as its ISO week-year note name.

    The ISO week-year is not the calendar year in the last days of December,
    which is why ``strftime("%Y")`` cannot be used here. Neovim's
    ``getISOWeek()`` applies the same Thursday rule, so the two agree.

    Args:
        day: The date to format.

    Returns:
        The weekly note name, such as ``"2026-W40"``.

    Examples:
        >>> iso_week(date(2026, 10, 4))
        '2026-W40'
        >>> iso_week(date(2025, 12, 29))
        '2026-W01'
        >>> iso_week(date(2026, 12, 31))
        '2026-W53'
    """
    year, week = day.isocalendar()[:2]
    return "%d-W%02d" % (year, week)


def quarter(day):
    """Format a date as its quarterly note name.

    Args:
        day: The date to format.

    Returns:
        The quarterly note name, such as ``"2026-Q4"``.

    Examples:
        >>> quarter(date(2026, 10, 4))
        '2026-Q4'
        >>> quarter(date(2026, 1, 1))
        '2026-Q1'
        >>> quarter(date(2026, 3, 31))
        '2026-Q1'
    """
    return "%s-Q%d" % (day.strftime("%Y"), (day.month - 1) // 3 + 1)


def next_weekday(day, weekday):
    """Return the next date falling on a weekday, never ``day`` itself.

    The ``or 7`` is the point of this function. BSD ``date -v+mon`` returns
    today when today is a Monday, so ``;mon`` used to link to the note you were
    already writing in.

    Args:
        day: The date to count forward from.
        weekday: Target weekday as a Monday-zero index, matching
            ``date.weekday()``.

    Returns:
        The date of the next such weekday, between 1 and 7 days ahead.

    Examples:
        >>> next_weekday(date(2026, 10, 4), 0)   # Sunday -> Monday
        datetime.date(2026, 10, 5)
        >>> next_weekday(date(2026, 10, 4), 6)   # Sunday -> a week on
        datetime.date(2026, 10, 11)
        >>> next_weekday(date(2026, 10, 5), 0)   # Monday -> a week on
        datetime.date(2026, 10, 12)
    """
    delta = (weekday - day.weekday()) % 7
    return day + timedelta(days=delta or 7)


def last_weekday(day, weekday):
    """Return the previous date falling on a weekday, never ``day`` itself.

    Args:
        day: The date to count back from.
        weekday: Target weekday as a Monday-zero index, matching
            ``date.weekday()``.

    Returns:
        The date of the previous such weekday, between 1 and 7 days back.

    Examples:
        >>> last_weekday(date(2026, 10, 4), 4)   # Sunday -> Friday
        datetime.date(2026, 10, 2)
        >>> last_weekday(date(2026, 10, 4), 6)   # Sunday -> a week back
        datetime.date(2026, 9, 27)
    """
    delta = (day.weekday() - weekday) % 7
    return day - timedelta(days=delta or 7)


def shift_months(day, months):
    """Shift a date by whole months, anchored mid-month.

    The result is anchored on the 15th so that stepping from a long month into
    a short one cannot overflow: ``timedelta(days=30)`` from 31 January lands in
    March, which would name the wrong note.

    Args:
        day: The date to shift from.
        months: Months to add; negative shifts back.

    Returns:
        A date in the target month, on the 15th.

    Examples:
        >>> shift_months(date(2026, 1, 31), 1)
        datetime.date(2026, 2, 15)
        >>> shift_months(date(2026, 10, 4), 3)
        datetime.date(2027, 1, 15)
        >>> shift_months(date(2026, 1, 4), -1)
        datetime.date(2025, 12, 15)
    """
    total = day.year * 12 + (day.month - 1) + months
    return date(total // 12, total % 12 + 1, 15)


def split_offset(spec):
    """Split a period spec into its name and signed offset.

    Args:
        spec: A period name with an optional trailing signed integer.

    Returns:
        A ``(name, offset)`` tuple; the offset is 0 when none is given.

    Examples:
        >>> split_offset("week")
        ('week', 0)
        >>> split_offset("month+1")
        ('month', 1)
        >>> split_offset("quarter-2")
        ('quarter', -2)
    """
    for index, char in enumerate(spec):
        if char in "+-":
            return spec[:index], int(spec[index:])
    return spec, 0


def resolve(spec, today):
    """Resolve a spec to an Obsidian note name.

    ``today`` is a parameter rather than a call to ``date.today()`` so that this
    function stays pure and the examples can pin a date.

    Args:
        spec: One of the specs listed in ``USAGE``.
        today: The date the spec is relative to.

    Returns:
        The note name, without brackets or a folder path.

    Raises:
        ValueError: If the spec or weekday name is not recognised.

    Examples:
        >>> sunday = date(2026, 10, 4)
        >>> resolve("today", sunday)
        '2026-10-04'
        >>> resolve("yesterday", sunday)
        '2026-10-03'
        >>> resolve("tomorrow", sunday)
        '2026-10-05'
        >>> resolve("next:mon", sunday)
        '2026-10-05'
        >>> resolve("last:fri", sunday)
        '2026-10-02'
        >>> resolve("week", sunday)
        '2026-W40'
        >>> resolve("week+1", sunday)
        '2026-W41'
        >>> resolve("week-1", sunday)
        '2026-W39'
        >>> resolve("month", sunday)
        '2026-10'
        >>> resolve("month+1", date(2026, 1, 31))
        '2026-02'
        >>> resolve("quarter", sunday)
        '2026-Q4'
        >>> resolve("quarter+1", sunday)
        '2027-Q1'
        >>> resolve("year", sunday)
        '2026'
        >>> resolve("nope", sunday)
        Traceback (most recent call last):
        ValueError: unknown spec: nope
        >>> resolve("next:funday", sunday)
        Traceback (most recent call last):
        ValueError: unknown weekday: funday
    """
    if spec in RELATIVE_DAYS:
        return (today + timedelta(days=RELATIVE_DAYS[spec])).isoformat()

    for prefix, pick in (("next:", next_weekday), ("last:", last_weekday)):
        if spec.startswith(prefix):
            name = spec[len(prefix):]
            if name not in WEEKDAYS:
                raise ValueError("unknown weekday: %s" % name)
            return pick(today, WEEKDAYS.index(name)).isoformat()

    name, offset = split_offset(spec)
    if name == "week":
        return iso_week(today + timedelta(weeks=offset))
    if name == "month":
        return shift_months(today, offset).strftime("%Y-%m")
    if name == "quarter":
        return quarter(shift_months(today, offset * 3))
    if name == "year":
        return shift_months(today, offset * 12).strftime("%Y")

    raise ValueError("unknown spec: %s" % spec)


def main(argv):
    """Print the note name for one spec.

    Args:
        argv: Process arguments, including the program name.

    Returns:
        A process exit status: 0 on success, 1 on a bad spec, 2 on bad usage.
    """
    if len(argv) != 2:
        sys.stderr.write(USAGE)
        return 2
    try:
        print(resolve(argv[1], date.today()))
    except ValueError as err:
        sys.stderr.write("obsidian_date: %s\n\n%s" % (err, USAGE))
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
