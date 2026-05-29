# Linux Survival Cheat Sheet
## Database Curation & Loading Training — 1k1RG, June 3–4 2026

> **PLACEHOLDER — PDF not yet generated.**
> Replace this file with the printed/designed PDF before the training.
> To generate a PDF: open in any Markdown viewer and export, or use your designed version.

---

## Where am I? What's here?

| Command | What it does |
|---|---|
| `pwd` | Print current directory |
| `ls` | List files |
| `ls -lh` | List with sizes, human-readable |
| `ls -la` | Include hidden files |
| `cd foldername` | Change into folder |
| `cd ..` | Go up one level |
| `cd ~` | Go to home directory |

## Viewing files

| Command | What it does |
|---|---|
| `cat file.txt` | Print whole file |
| `head -20 file.txt` | First 20 lines |
| `tail -20 file.txt` | Last 20 lines |
| `less file.txt` | Page through (q to quit) |
| `wc -l file.txt` | Count lines |

## Editing files

| Command | What it does |
|---|---|
| `nano file.txt` | Simple editor (Ctrl+O save, Ctrl+X exit) |
| `vi file.txt` | Vim editor (i = insert, Esc then :wq = save+quit) |

## File operations

| Command | What it does |
|---|---|
| `cp source dest` | Copy file |
| `mv source dest` | Move / rename |
| `rm file.txt` | Delete file (no undo!) |
| `mkdir foldername` | Create directory |
| `rmdir foldername` | Remove empty directory |

## Searching

```bash
grep "pattern" file.txt          # Lines matching pattern
grep -r "pattern" ./folder/      # Recursive search
grep -i "pattern" file.txt       # Case-insensitive
find . -name "*.vcf"             # Find files by name
```

## Pipes and redirection

```bash
command | another_command        # Pipe output to next command
command > output.txt             # Write output to file (overwrites)
command >> output.txt            # Append to file
command 2>&1 | tee log.txt       # Log stdout+stderr to file AND screen
```

## Running scripts

```bash
bash myscript.sh                 # Run a bash script
chmod +x myscript.sh             # Make executable
./myscript.sh                    # Run executable script
bash myscript.sh arg1 arg2       # Pass arguments
```

## Processes

| Command | What it does |
|---|---|
| `Ctrl+C` | Cancel running command |
| `Ctrl+Z` | Suspend to background |
| `bg` | Resume in background |
| `fg` | Bring back to foreground |
| `ps aux` | List all processes |
| `kill PID` | Terminate process by ID |

## Useful tricks

```bash
Tab              # Autocomplete paths and commands
Up/Down arrows   # Browse command history
Ctrl+R           # Search command history
!!               # Repeat last command
!pg              # Repeat last command starting with 'pg'
history | tail   # Show recent commands
```

## Permissions (quick reference)

```bash
chmod 755 script.sh    # Owner: rwx  Group: r-x  Others: r-x
chmod 644 file.txt     # Owner: rw-  Group: r--  Others: r--
ls -l                  # See permissions in listing
```
