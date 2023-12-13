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


root = FinalChArray[0][0] + 24
#print("root =",root) #Debug
MajorScale = [root-5,root-3,root-1, root, root+2, root+4, root+5, root+7, root+9, root+11,root+12]
MinorScale = [root-5,root-4,root-2, root, root+2, root+3, root+5, root+7, root+8, root+10,root+12]
RhArray = [0.25,0.5,1,2]

FinalMeloNoteArray = []
FinalMeloRhArray = []

if "m" in ChArray[0]: #Minor Melody

  #First note generation:
  coin = random.randint(1,10)
  if coin <= 5:
    fn = 3 #first note tracker
     #First Melo note is Tonic
  else:
    if coin <= 8:
      fn = 7 #First Melo note is Fifth
    else:
      fn = 5 #First Melo note is Third
  FinalMeloNoteArray.append(MinorScale[fn])
  FinalMeloRhArray.append(RhArray[random.randint(2,3)])

  #Melody generation:
  for i in range(random.randint(16-2,48-2)):
    #print("Fn = ",fn) #Debug
    #print(FinalMeloNoteArray) #Debug
    coin = random.randint(1,100)
    #print("Coin = ",coin) #Debug
    if coin <= 30 and fn < len(MinorScale)-1:
      fn = fn+1 #Append upper second
      FinalMeloRhArray.append(RhArray[random.randint(0,1)])
    else:
      if coin <= 60 and fn > 0:
        fn = fn-1 #Append lower second
        FinalMeloRhArray.append(RhArray[random.randint(0,1)])
      else:
        if coin <= 65 and fn < len(MinorScale)-2:
          fn = fn+2 #Append upper third
          FinalMeloRhArray.append(RhArray[random.randint(0,3)])
        else:
          if coin <= 70 and fn > 1:
            fn = fn-2 #Append lower third
            FinalMeloRhArray.append(RhArray[random.randint(0,3)])
          else:
            if coin <= 75 and fn < len(MinorScale)-3:
              fn = fn+3 #Append upper fourth
              FinalMeloRhArray.append(RhArray[random.randint(0,3)])
            else:
              if coin <= 80 and fn > 2:
                fn = fn-3 #Append lower fourth
                FinalMeloRhArray.append(RhArray[random.randint(0,3)])
              else:
                if coin <= 85 and fn < len(MinorScale)-4:
                  fn = fn+4 #Append upper fifth
                  FinalMeloRhArray.append(RhArray[random.randint(0,3)])
                else:
                  if coin <= 90 and fn > 3:
                    fn = fn-4 #Append lower fifth
                    FinalMeloRhArray.append(RhArray[random.randint(0,3)])
                  else:
                    if coin <= 95 and fn < len(MinorScale)-5:
                      fn = fn+5 #Append upper sixth
                      FinalMeloRhArray.append(RhArray[random.randint(0,3)])
                    else:
                      if coin <= 100 and fn > 4:
                        fn = fn-5 #Append lower sixth
                        FinalMeloRhArray.append(RhArray[random.randint(0,3)])
                      else:
                        if fn < len(MinorScale)-7:
                          fn = fn+7 #Append upper octave
                          FinalMeloRhArray.append(RhArray[random.randint(0,3)])
                        else:
                          if fn > 6:
                            fn = fn-7 #Append lower octave
                            FinalMeloRhArray.append(RhArray[random.randint(0,3)])


    FinalMeloNoteArray.append(MinorScale[fn])

  #Last note generation:
  if abs(FinalMeloNoteArray[len(FinalMeloNoteArray)-1] - MinorScale[10]) >= abs(FinalMeloNoteArray[len(FinalMeloNoteArray)-1] - MinorScale[3]): #Appending closest tonic
    FinalMeloNoteArray.append(MinorScale[3])
  else:
    FinalMeloNoteArray.append(MinorScale[10])
  FinalMeloRhArray.append(RhArray[random.randint(2,3)])

  #print(FinalMeloNoteArray) #Debug
  #print(MinorScale) #Debug

else: #Major Melody

  #First note generation:
  coin = random.randint(1,10)
  if coin <= 5:
    fn = 3 #first note tracker
    FinalMeloNoteArray.append(MajorScale[fn]) #First Melo note is Tonic
  else:
    if coin <= 8:
      fn = 7
      FinalMeloNoteArray.append(MajorScale[fn]) #First Melo note is Fifth
    else:
      fn = 5
      FinalMeloNoteArray.append(MajorScale[fn]) #First Melo note is Third

  #Melody Generation:
  for i in range(random.randint(12-2,32-2)):
    #print("Fn = ",fn) #Debug
    #print(FinalMeloNoteArray) #Debug
    coin = random.randint(1,100)
    #print("Coin = ",coin) #Debug
    if coin <= 30 and fn < len(MajorScale)-1:
      fn = fn+1 #Append upper second
      FinalMeloRhArray.append(RhArray[random.randint(0,1)])
    else:
      if coin <= 60 and fn > 0:
        fn = fn-1 #Append lower second
        FinalMeloRhArray.append(RhArray[random.randint(0,1)])
      else:
        if coin <= 65 and fn < len(MajorScale)-2:
          fn = fn+2 #Append upper third
          FinalMeloRhArray.append(RhArray[random.randint(0,3)])
        else:
          if coin <= 70 and fn > 1:
            fn = fn-2 #Append lower third
            FinalMeloRhArray.append(RhArray[random.randint(0,3)])
          else:
            if coin <= 75 and fn < len(MajorScale)-3:
              fn = fn+3 #Append upper fourth
              FinalMeloRhArray.append(RhArray[random.randint(0,3)])
            else:
              if coin <= 80 and fn > 2:
                fn = fn-3 #Append lower fourth
                FinalMeloRhArray.append(RhArray[random.randint(0,3)])
              else:
                if coin <= 85 and fn < len(MajorScale)-4:
                  fn = fn+4 #Append upper fifth
                  FinalMeloRhArray.append(RhArray[random.randint(0,3)])
                else:
                  if coin <= 90 and fn > 3:
                    fn = fn-4 #Append lower fifth
                    FinalMeloRhArray.append(RhArray[random.randint(0,3)])
                  else:
                    if coin <= 95 and fn < len(MajorScale)-5:
                      fn = fn+5 #Append upper sixth
                      FinalMeloRhArray.append(RhArray[random.randint(0,3)])
                    else:
                      if coin <= 100 and fn > 4:
                        fn = fn-5 #Append lower sixth
                        FinalMeloRhArray.append(RhArray[random.randint(0,3)])
                      else:
                        if fn < len(MajorScale)-7:
                          fn = fn+7 #Append upper octave
                          FinalMeloRhArray.append(RhArray[random.randint(0,3)])
                        else:
                          if fn > 6:
                            fn = fn-7 #Append lower octave
                            FinalMeloRhArray.append(RhArray[random.randint(0,3)])


    FinalMeloNoteArray.append(MajorScale[fn])

  #Last note generation:
  if abs(FinalMeloNoteArray[len(FinalMeloNoteArray)-1] - MajorScale[10]) >= abs(FinalMeloNoteArray[len(FinalMeloNoteArray)-1] - MajorScale[3]): #Appending closest tonic
    FinalMeloNoteArray.append(MajorScale[3])
  else:
    FinalMeloNoteArray.append(MajorScale[10])
  FinalMeloRhArray.append(RhArray[3])

  #print(FinalMeloNoteArray) #Debug
  #print(MajorScale) #Debug

# print(FinalMeloNoteArray)


# Controling FinalMeloRhArray for the Melody to be regular
if sum(FinalMeloRhArray) - 16 >= 8:
  MaxRh = 4*8
else:
  MaxRh = 4*4

#print(FinalMeloRhArray) #Debug
#print(sum(FinalMeloRhArray)) #Debug

while MaxRh != sum(FinalMeloRhArray):
  if -1 < MaxRh - sum(FinalMeloRhArray) < 1:
    FinalMeloRhArray[len(FinalMeloRhArray)-1] = FinalMeloRhArray[len(FinalMeloRhArray)-1] + (MaxRh - sum(FinalMeloRhArray))
  else:
    rand = random.randint(0,len(FinalMeloRhArray)-1)
    if sum(FinalMeloRhArray) > MaxRh:
      if FinalMeloRhArray[rand] > 0.5:
        FinalMeloRhArray[rand] = FinalMeloRhArray[rand]/2
    else:
      if sum(FinalMeloRhArray) < MaxRh:
        if FinalMeloRhArray[rand] < 2:
          FinalMeloRhArray[rand] = FinalMeloRhArray[rand]*2

# print(FinalMeloRhArray)
# print(sum(FinalMeloRhArray)) #Must be 16 or 32

data = {
  "chord_progression": {
    "notes": FinalChArray,
    "note_lengths": FinalChRhArray
  },
  "bassline": {
    "notes": FinalBassNoteArray,
    "note_lengths": FinalBassRhArray
  },
  "melody": {
    "notes": FinalMeloNoteArray,
    "note_lengths": FinalMeloRhArray
  }
}

json_string = json.dumps(data)
print(json_string)