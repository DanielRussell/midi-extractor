# Caveat

This is a personal toy/demo/exploration project.  I welcome questions
or suggestions, but can't commit to anything.

# MIDI Reader

Turn a MIDI file into something that can be played on an Arduino.

Initial Proof of Concept:
* Download a MIDI file
* Open in GarageBand.  Try to figure out which track and/or channel you want.
* Read through the MIDI file, output a valid C header file
* Include the header file in your Arduino code and call `play_<song>()`

Initial implementation inspired by the reader snippet in the
[midilib](https://github.com/jimm/midilib) README.

# References

For MIDI files, check out [freemidi.org](There are several sites with
MIDI files) and [BitMidi](https://bitmidi.com/) or your favorite
search engine.

Gems:
* [midilib](https://github.com/jimm/midilib) to parse MIDI files.
* [music](https://www.rubydoc.info/github/cheerfulstoic/music) to convert a note to Hz

* [MIDI file format](http://www.music.mcgill.ca/~ich/classes/mumt306/StandardMIDIfileformat.html).  Especially useful to see note mappings.
* [Musical Notes and their Frequencies](https://www.liutaiomottola.com/formulae/freqtab.htm).  Not necessary if you use the `music` gem, above.  But handy.
* [Super Mario](https://www.princetronics.com/supermariothemesong/) theme songs in Arduino
* [Midi to Arduino](https://www.extramaster.net/tools/midiToArduino/.content).  This exists, but I've not looked at the source (if it's even available).

There are many online instructions for attaching speakers to Arduino,
just search around 'til you find one that more or less aligns with
your kit.

## Notes

(Stream-of-consciousness notes about MIDI, individual files/songs, etc)

* The file format seems standard (framing, etc), but actually
  extracting *notes* isn't.  I've downloaded 3 songs so far and am
  trying to grab the "closest-to-melody"
  * `Happy` is on track 4 channel 0.  All tracks have a single channel.
  * `Roar` is on track 1 channel 3.  There's one track with multiple channels.
  * `JamesBond` is on track 5 channel 3.

* To find the channel and track:
  * Play the tune in GarageBand.  Mute all the tracks you don't want
    to hear to confirm that's the track.
  * Look at the starting note sequence (e.g. E1 F#1 F#1 F#1 F#1).
  * In `reader.rb`, change 'debug' to `true`.  Run the script, send
    the output to a file or pipe it into `less`.
  * Search the file for E1, see if you can find an F#1 etc after it.
  * Potentially set a breakpoint and inspect `e` to see the track and
    channel
  * Once you've isolated the track and channel, set `debug` back to
    `false`, run `reader.rb` and send the output to the Arduino
    project directory.

## TODO

* Put the Arduino code in this repo as well (perhaps a library?)
* Streamline the "find the track/channel" process
* How to play the tunes (arbitrary Hz + duration) on macOS?
* Extract the tempo instead of the bogus `denominator`
* Ability to adjust octaves
* Song config file so it's not inline in code
