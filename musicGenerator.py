import random
from music21 import *
import json


HrChArray = ["C","Am","G","Em","D","Bm","A","F#m","E","C#m","B","G#m","F#","Ebm","Db","Bbm","Ab","Fm","Eb","Cm","Bb","Gm","F","Dm","C","Am","G","Em","D"]
Ch1n = random.randint(0,23)
ProbNumber = random.randint(1,10)
Ch1 = HrChArray[Ch1n]
FinalNArray = [Ch1n]
ChArray = [Ch1]

for i in range(3) :
  ProbNumber = random.randint(1,10)
  if ProbNumber <= 5:
      Ch2n = random.randint(FinalNArray[i] - 1, FinalNArray[i] + 1)
      Ch2 = HrChArray[Ch2n]
  if 5 < ProbNumber <= 8:
      coin = random.randint(1,2)
      if coin == 1:
        Ch2n = FinalNArray[i] - 2
      if coin == 2:
        Ch2n = FinalNArray[i] + 2
      Ch2 = HrChArray[Ch2n]
  if ProbNumber == 9:
      Ch2n = FinalNArray[i] - 3
      Ch2 = HrChArray[Ch2n]
  if ProbNumber == 10:
      Ch2n = FinalNArray[i] + 3
      Ch2 = HrChArray[Ch2n]
  ChArray.append(Ch2)
  FinalNArray.append(Ch2n)
# print(ChArray)

CrChArrayFlat = ["C","Db","D","Eb","E","F","Gb","G","Ab","A","Bb","B","C","Db","D","Eb","E","F","Gb","G","Ab","A","Bb","B"]
CrChArraySharp = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B","C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
FullChArray = []

# Generating FinalChArray:
for i in  ChArray:
  TempArray = []
  if "m" in i:
    TempArray.append(i.replace("m",""))
    if "#" in i or i == "Bm":
      TempArray.append(CrChArraySharp[CrChArraySharp.index(i.replace("m",""))+3])
      TempArray.append(CrChArraySharp[CrChArraySharp.index(i.replace("m",""))+7])
    else:
      TempArray.append(CrChArrayFlat[CrChArrayFlat.index(i.replace("m",""))+3])
      TempArray.append(CrChArrayFlat[CrChArrayFlat.index(i.replace("m",""))+7])
  else:
    TempArray.append(i)
    if "b" in i:
      TempArray.append(CrChArrayFlat[CrChArrayFlat.index(i)+4])
      TempArray.append(CrChArrayFlat[CrChArrayFlat.index(i)+7])
    else:
      TempArray.append(CrChArraySharp[CrChArraySharp.index(i)+4])
      TempArray.append(CrChArraySharp[CrChArraySharp.index(i)+7])
  FullChArray.append(TempArray)

#Generating FinalChRhArray:
FinalChRhArray = [4,4,4,4]

# print(FullChArray)
# print(FinalChRhArray)

FinalChArray = []
for a in FullChArray:
  TempArray = []
  for b in a:
    TempArray.append(note.Note(b).pitch.pitchClass+48)
  FinalChArray.append(TempArray)


FinalBassNoteArray = []
FinalBassRhArray = []

coin = random.randint(1,4)

if coin == 1:
  # print("Basic Bass :")
  for i in range(4):
      FinalBassNoteArray.append(note.Note(FullChArray[i][0]).pitch.pitchClass+24)
      FinalBassRhArray.append(4)

if coin == 2:
  # print("Fourth Descending Bass :")
  for i in range(4):
    FinalBassNoteArray.append(note.Note(FullChArray[i][0]).pitch.pitchClass+24)
    FinalBassRhArray.append(3)
    FinalBassNoteArray.append(note.Note(FullChArray[i][0]).pitch.pitchClass+19)
    FinalBassRhArray.append(1)

if coin == 3:
  # print("Octave Bass :")
  for i in range(4):
    for a in range(2):
      for b in range(2):
        FinalBassNoteArray.append(note.Note(FullChArray[i][0]).pitch.pitchClass+24+12*b)
        FinalBassRhArray.append(1)

if coin == 4:
  # print("Fast Octave Bass :")
  for i in range(4):
    for a in range(4):
      for b in range(2):
        FinalBassNoteArray.append(note.Note(FullChArray[i][0]).pitch.pitchClass+24+12*b)
        FinalBassRhArray.append(0.5)

# print(FinalBassNoteArray)
# print(FinalBassRhArray)

data = {
  "chord_progression": {
    "notes": FinalChArray,
    "note_lengths": FinalChRhArray
  },
  "bassline": {
    "notes": FinalBassNoteArray,
    "note_lengths": FinalBassRhArray
  }
}

json_string = json.dumps(data)
print(json_string)