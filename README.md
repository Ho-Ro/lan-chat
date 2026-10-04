# lan-chat

Quick text exchange for a small local network.
Peer-to-peer: every instance is identical, there is no server.

## Usage

```
lan-chat                  start with your system username
lan-chat --name "Ada"   start with a custom name
```

Only one instance per machine: a second instance cannot bind
the UDP port and exits with an error.

### Mouse and keyboard

| Action | Effect |
|---|---|
| click a message | copy the message text (no timestamp, no sender) and select it |
| drag in the history | select char by char |
| double-click | select one word |
| triple-click | select the whole received message |
| drag text / small text file onto the window | insert into the input |
| drag a user (or double-click) | private note to that user |
| Enter | send |
| Shift+Enter | newline in the input |
| Esc | cancel private note |

Middle-click paste (X11 primary selection) works as usual.
Buttons: Send, Copy whole chat, Copy last received.

## Principle

Connectionless UDP broadcast on port 5055:

- every 2 seconds each instance broadcasts a `hello` datagram
  with its random instance id and display name
- a chat message is one broadcast datagram (`msg`); a private
  note is a `pm` datagram addressed to one instance id
- peers are pruned after 8 seconds without a heartbeat; a
  `bye` datagram is sent on exit
- one datagram = one message, max 4000 characters

No TCP, no connections, no handshakes: peers appear and
disappear freely, and a crashed peer times out by itself.

## Solution (design decisions)

- Copy and paste first: every copy action yields the bare
  message text; the timestamp and sender are never included.
- A received private note raises the peer's window (also from
  minimized); normal chat never steals focus.
- Single file, one deliberate dependency: PyQt6, because the
  standard library cannot do OS-level drag and drop.
- Message text and its offset are stored per paragraph
  (`QTextBlockUserData`), so selection can cover the message
  only.
- All peer text is HTML-escaped before display.
- Security: plaintext, no authentication - only for trusted
  networks; anyone on the LAN can use any name.

## Build

```
make deb        # build a debian package (equivs-build)
make debinstall # install the latest package
make clean
```

The package installs `lan-chat` to `/usr/bin`, the icon to
`/usr/share/pixmaps` and a `.desktop` launcher, and depends
on `python3-pyqt6`.
