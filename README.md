# posh-podcastdownloader

A PowerShell script that downloads every episode from the **Chicane Presents Sun Sets** podcast and stores the MP3 files in a folder called `ChicaneSunsets`. The script runs downloads in parallel (up to 10 concurrent jobs) and displays a live progress bar.

## Prerequisites
| Requirement | Details |
| ----------- | ------- |
| **PowerShell version** | 7.x recommended (native `-Parallel`). PowerShell 5.1 works with the *ThreadJob* module. |
| **Internet access** | Needed to reach the feed URL and MP3 files. |
| **Write permission** | The script creates a folder and writes files in the current directory. |
| **Modules** | No external modules; only built‑in cmdlets (`Invoke‑RestMethod`, `Select‑Xml`, `Invoke‑WebRequest`, etc.). |

---

## Step‑by‑step flow

1. Fetch the podcast XML from http://portal-api.thisisdistorted.com/xml/chicane-presents-sun-sets.
1. Parse the Atom XML and use XPath to find the relevant data nodes.
1. Process each entry in parallel.
1. Derive a safe filename from the episode title.
1. Create the output directory if needed.
1. Download the MP3 only if it isn’t already present.
1. Update progress after each download, showing a live percentage.
1. Report completion with the total number of successfully downloaded episodes.

It automates bulk downloading of all podcast episodes listed in the given XML feed, storing each MP3 in a folder, while providing a visual progress indicator and avoiding duplicate downloads.
