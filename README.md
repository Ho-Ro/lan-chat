# lan-chat

Quick text exchange for a small local network.
Peer-to-peer: every instance is identical, there is no server.

## Usage

```
lan-chat                start with your system username
lan-chat --name "Ada"   start with a custom name
```

Every instance has a random id, so several instances can
coexist: multiple instances per machine work, and two PCs
where you are logged in as the same user show up as
"name@machine" (private notes still reach the right one).

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

- every 2 seconds each instance broadcasts a `hello`
  datagram with its random instance id, display name
  and machine name - once as subnet-directed
  broadcast on every network interface, plus a
  unicast copy to every known peer (WiFi
  retransmits unicast, so presence survives lost
  broadcasts)
- a chat message (`msg`) or private note (`pm`, addressed
  to one instance id) is sent as subnet-directed
  broadcast plus unicast to every known peer; each
  carries a sequence number and duplicates are
  ignored, so WiFi broadcast loss cannot drop it
- a peer is dimmed after 8 seconds without a heartbeat
  and removed after 60 seconds; a `bye` datagram is
  sent on exit
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
