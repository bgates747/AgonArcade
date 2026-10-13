# Choplifter level research — 2026-10-06

The original 1982 game uses one scrolling rescue battlefield with four barracks
and 64 hostages, rather than a sequence of different numbered levels. The three
sorties are helicopter lives, not three separate maps. Later Sega versions have
a different mission structure, so the number depends on which version one
remembers. This game follows the original single-battlefield structure.

1. [Original Brøderbund manual, Apple II scan](https://mirrors.apple2.org.za/ftp.apple.asimov.net/documentation/games/misc/Choplifter%20Manual.pdf).
   Primary contemporary reference for the original rescue game.
2. [Atari 5200 instruction manual](https://atariage.com/manual_html_page.php?SoftwareID=2057).
   Describes 64 hostages, a 16-passenger helicopter, three helicopters, and the
   game ending when the third helicopter is lost or the hostages are saved/lost.
3. [Atari 7800 instruction manual](https://atariage.com/manual_html_page.php?SoftwareID=2121).
   Explicitly describes four barracks with 16 hostages apiece and three sorties.
4. [Sega Master System US manual](https://www.smspower.org/Manuals/Choplifter-SMS-US).
   Describes rescue sites and differing progression rules. It should not be
   treated as a specification of the 1982 original. No arcade stage count is
   asserted here: variant descriptions encountered during research disagree.

Implementation decisions: one original-style battlefield; four camps; 16 seats;
three lives; unlimited ammunition; gunfire and bombs; tanks and jets. The
palette, visuals, flight model, scoring and timings are new, with gentle landing
and automatic boarding/unloading made explicit to the player.
