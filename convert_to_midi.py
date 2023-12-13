import json
from music21 import stream, note, chord, meter, tempo
import sys

def create_midi_from_music_notation(music_notation):
    chord_progression_data = music_notation["chord_progression"]
    bassline_data = music_notation["bassline"]
    melody_data = music_notation.get("melody", None)

    # Extract chord notes and lengths from the provided chord progression data
    chord_notes = chord_progression_data["notes"]
    note_lengths = chord_progression_data["note_lengths"]

    # Create a stream for the chord progression MIDI file
    chord_progression_stream = stream.Score()
    chord_progression_part = stream.Part()

    # Add a time signature and tempo to the part
    chord_progression_part.append(meter.TimeSignature('4/4'))
    chord_progression_part.append(tempo.MetronomeMark(number=120))

    # Iterate through chord notes and lengths to create notes
    for chord_item, length in zip(chord_notes, note_lengths):
        chord_notes_obj = [note.Note(n) for n in chord_item]
        chord_obj = chord.Chord(chord_notes_obj)
        chord_obj.quarterLength = length
        chord_progression_part.append(chord_obj)

    # Append the part to the chord progression stream
    chord_progression_stream.append(chord_progression_part)

    # Write the chord progression MIDI file
    chord_progression_stream.write('midi', fp='chord_progression.mid')

    # Extract bassline notes and lengths from the provided bassline data
    bassline_notes = bassline_data["notes"]
    bassline_note_lengths = bassline_data["note_lengths"]

    # Create bassline notes and lengths
    bassline_notes_obj = [note.Note(n) for n in bassline_notes]
    bassline_stream = stream.Score()
    bassline_part = stream.Part()
    for bass_note, length in zip(bassline_notes_obj, bassline_note_lengths):
        bass_note.quarterLength = length
        bassline_part.append(bass_note)

    # Append the bassline part to the bassline stream
    bassline_stream.append(bassline_part)

    # Write the bassline MIDI file
    bassline_stream.write('midi', fp='bassline.mid')

    # If melody data is provided, handle it
    if melody_data:
        melody_notes = melody_data["notes"]
        melody_note_lengths = melody_data["note_lengths"]

        # Create melody notes and lengths
        melody_notes_obj = [note.Note(n) for n in melody_notes]
        melody_stream = stream.Score()
        melody_part = stream.Part()
        for melody_note, length in zip(melody_notes_obj, melody_note_lengths):
            melody_note.quarterLength = length
            melody_part.append(melody_note)

        # Append the melody part to the melody stream
        melody_stream.append(melody_part)

        # Write the melody MIDI file
        melody_stream.write('midi', fp='melody.mid')

def main(json_file):
    with open(json_file, 'r') as file:
        music_notation = json.load(file)
    
    create_midi_from_music_notation(music_notation)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python convert_to_midi.py <input_json_file>")
        sys.exit(1)

    input_json_file = sys.argv[1]
    main(input_json_file)
