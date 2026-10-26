# Eudora 7.2

**[Deutsch](README.md) | English**

The email client **Eudora 7.1, buildable again** with Visual Studio 2022 on
Windows 10 and 11.

In 2018 the [Computer History
Museum](https://computerhistory.org/blog/the-eudora-email-client-source-code/)
released the Eudora source code with Qualcomm's permission, as an archive,
not as a buildable project. This repository turns it back into a program
you can build and use: it runs on current Windows and sends and receives
mail over TLS 1.3.

The project is maintained in German. This page is a short English summary
and deliberately leaves out details that change from release to release.
The German [README.md](README.md) is the reference.

## Before the first start: make a backup

If you already use Eudora 7.1 or Hermes, **back up** your `Eudora.ini` and
your complete mail folder first. Use **separate folders**: this version and
an existing Eudora or Hermes write incompatible settings into the same
`Eudora.ini`. Running both on the same files is at your own risk.

## Try it

1. Download the latest package from the
   [Releases page](https://github.com/HansWurst81675/Eudora7.2/releases/latest).
2. Before unpacking: right-click the `.zip` → *Properties* → tick
   *Unblock* → *OK*. Otherwise Windows marks every unpacked file as
   downloaded and blocks `Eudora.exe`.
3. Unpack and double-click `Eudora starten.cmd` ("start Eudora"). Nothing
   needs to be installed.

## Known issues

The current list of known issues is kept in one place, in German:
[README.md, section "Bekannte Fehler"](README.md#bekannte-fehler).
Two points that come up often:

- **Microsoft Defender** may report `Eudora.exe` as a trojan
  ("Bearfoos"). This is a false positive based on heuristics; the program
  is built from the source in this repository. The files are not code-signed.
- **Drafts:** keep unfinished messages in the local `Out` mailbox
  (*File → Save*, Ctrl+S). Do not move drafts into an IMAP folder.

## Reporting a problem

[Issues](https://github.com/HansWurst81675/Eudora7.2/issues) are welcome in
English or German. Please include the version shown in the window title and,
if possible, the `eudora.log` from the mail folder.

## Building it yourself

Visual Studio 2022 with "Desktop development with C++" and one command; see
[Doku/BAUEN.md](Doku/BAUEN.md) (German).

## License

BSD 3-Clause with patent exclusion, as released by the Computer History
Museum; everything new in this project is under the same license. Full text
in [LICENSE](LICENSE).
