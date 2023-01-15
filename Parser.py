import os
import mido


Failed = False

DoALLFiles = True
ListFiles = True

## Volume
maxVolume = 150
minVolume = 15

midName = 'Midi/test.mid'

WorkspacePath = ''
#               'C:/Users/Admin/Desktop/Synapse-X/workspace/'

if not os.path.exists('Midi/'):
    os.mkdir('Midi/')
    raise Exception("Midi Folder Made\nAdd Midis to 'Midi/'")

if not os.path.exists(WorkspacePath+'RobloxMidiPlayer/'):
    os.mkdir(WorkspacePath+'RobloxMidiPlayer/')

def GetVolume(velocities):
    returnVar = 100
    sum = 0
    for v in velocities:
        sum += v
    average = sum/len(velocities)
    # print(velocities)
    if average > maxVolume:
        return maxVolume
    elif average < minVolume:
        return minVolume
    else:
        # print(average,end="\t")
        if average == 100:
            returnVar = 100
        elif average > 100:
            returnVar = average*(127/maxVolume)
        elif average > minVolume:
            returnVar = average
        else:
            returnVar = minVolume
        return returnVar
    
def getCmdTable(mid):
    Output = ""
    for v in mid:
        if v.type == 'set_tempo':
            tempo = v.tempo
            break
    # i = 0
    for v in mid:
        if v.type == 'set_tempo':
            tempo = v.tempo
        
        if mido.tick2second(v.time, mid.ticks_per_beat, tempo) > 0:
            Output += "\nSleep:" + str(v.time)
        
        if v.type == 'note_on':
            # print(type(v.note))
            Output += "\nPlay:"+str(v.note-35)+","+str(GetVolume([v.velocity])/100)

    worked = False
    while not worked:
        try:
            outputname = ""
            if not DoALLFiles:
                outputname = input("Enter output name: ")
            if outputname == "" or DoALLFiles:
                outputname = "".join(entry.name.split(".")[0:len(entry.name.split("."))-1])
            print(midName)
            with open(WorkspacePath+'RobloxMidiPlayer/'+outputname+'.txt', 'w+') as f:
                f.write(Output)
            worked = True
        except Exception as error:
            print(error)
            worked = False
    
    
if not DoALLFiles:
    if ListFiles == True:
        Files = {}
        i = 0
        with os.scandir('./Midi') as dirs:
            for entry in dirs:
                Files.update({i: entry.name})
                i += 1
        for i in range(len(Files)):
            print(i, "\t", Files[i])
        worked = False
        while not worked:
            try:
                filei = int(input("Enter a file number: "))
                midName = 'Midi/'+Files[filei]
                worked = True
            except:
                for i in range(len(Files)):
                    print(i, "\t", Files[i])
        

    mid = mido.MidiFile(midName)
    getCmdTable(mid)
else:
    with os.scandir('./Midi') as dirs:
        for entry in dirs:
            midName = 'Midi/'+entry.name
            mid = mido.MidiFile(midName)
            getCmdTable(mid)


