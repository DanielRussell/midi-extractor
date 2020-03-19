#!/usr/bin/env ruby
# frozen_string_literal: true

require 'byebug'
require 'midilib'
require 'midilib/io/seqreader'
require 'music'

song = ARGV[0]

want_track = 0
denominator = 1

case song
when 'Happy'
  want_track = 4
  want_channel = 0
  denominator = 7
when 'Roar'
  want_track = 1
  want_channel = 3
  denominator = 1
when 'JamesBond'
  want_track = 5
  want_channel = 3
  denominator = 1
else
  raise "Unknown song: #{song}"
end

debug = false

def note(val)
  MIDI::NoteEvent.pch_oct(val)
end

# Create a new, empty sequence.
seq = MIDI::Sequence.new

# Read the contents of a MIDI file into the sequence.
File.open("data/#{song}.mid", 'rb') do |file|
  seq.read(file) do |track, num_tracks, i|
    if debug
      # Print something when each track is read.
      puts "read track #{i} of #{num_tracks}"
      if track
        puts " #{track.name}"
        puts " #{track.instrument}"
        puts " #{track.events.length}"
      end
    end

    next unless i == want_track

    # Iterate over each event in the track.  Only pay attention to the
    # NoteOn.  When we see one, look at how long the note is played.
    # Also look at whether there was a rest (i.e. a non-zero delta
    # before the note is played.
    #

    # Header
    puts "uint16_t notes_#{song}[] = {"

    track.each do |e|
      e.print_decimal_numbers = true # default = false (print hex)
      e.print_note_names = true # default = false (print note numbers)

      if debug
        unless [MIDI::NoteOn].include? e.class
          puts e.class
          puts e.to_s
          next
        end
      end

      next unless [MIDI::NoteOn].include? e.class

      next unless want_channel == e.channel

      if debug
        puts e.to_s
        puts e.off.to_s
      end

      if e.delta_time != 0
        puts "  // Rest for #{e.delta_time}"
        puts "  0, #{(e.delta_time / denominator).to_i},"
      end

      # TODO: drops fractions of a Hz. OK?
      note = Music::Note.new(e.pch_oct)
      freq = note.frequency.to_i

      puts "  // Play #{e.pch_oct} for #{e.off.delta_time}"
      duration = (e.off.delta_time / denominator).to_i
      # duration = 80 if duration < 80
      puts "  #{freq}, #{duration},"
    end

    # Footer
    puts "0, 0 }; // notes_#{song}"
  end
end
