<!-- https://keepachangelog.com/en/1.1.0/ -->
# Changelog

## 1.0.0 - 2024-11-06

### Added

- Initial implementation for Windows and Android platforms; no compatibility testing were done, though.
- Initial implementation of features.
    - Select timezone offsets.
    - Select date and time in precision of minutes.
      Due to that built-in function `showTimePicker` provides only hour and minute,
      in this version user cannot pick a timestamp including seconds information ..
      but it's considered rarely needed and a manual two-digit addition should be easy even when required?
    - Persistent of last used timezone offset.
    - Additional functions attempt to speed up time picking:
        - Long press on date picker button: set date and time to current date time, in picked timezone offset.
        - Long press on time picker button: set time to 00:00.
