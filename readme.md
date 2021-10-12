# OJazz

## OStim Music Addon

Adds music to Ostim scenes, with the ability to for users to create modular music packs.

### Features

* Automatically plays music during OStim scenes.
* Integrated Sky-UI Widget to show song title, artist, length and license.
* Modular, json based system to load new music packs into the mod.
* A small selection of Creative Commons CC BY-NC music with a sexy feel.

### Requirements

* [Ostim SE](https://github.com/Sairion350/OStim) (and all its' requirements.)
* [NL_MCM](https://www.nexusmods.com/skyrimspecialedition/mods/49127) (and all its' requirements.)

### Installation

1. Install all requirements.
2. Install OJazz.

## Information for Modders

### How to create a music pack

1. Convert your songs to ``.wav`` and place them in ``Data\Sound\Fx\OJazz``
2. Create a new esp in the ck.
3. In that esp, create a **Sound Descriptor** that points to your wav file.
4. Also create a **Sound Marker** that points to the sound descriptor.
5. Create a new ``.json`` file in ``Data\Interface\exported\widgets\ojazz\``
6. It should contain the format explained in the **Understanding Database Format** section below.
7. Load into the game and your music pack should appear in the MCM, if it doesn't click the "Rebuild Database" option.

### Understanding Database Format

The music database is built by combining every .json file inside ``Data\Interface\exported\widgets\ojazz\``, and all information about the song is derived from it.

A single database entry looks like this:

```json
    "Lophophora Williamsii": {
      "Enabled": 1,
      "Form": "__formData|ojazz.esp|0x80C",
      "Artist": "Eldad Tsabary",
      "Title": "Lophophora Williamsii",
      "Length": "2:44",
      "License": "CC BY-NC"
    }
```

And can be broken down like so:

* ``"Lophophora Williamsii": {`` - Song Index Key, used to uniquely identify the song in the database.
* ``"Enabled": 1,`` - Whether the song should be enabled by default.
* ``"Form": "__formData|ojazz.esp|0x80C",`` - The FormData record that points to the Sound Marker.
* ``"Artist": "Eldad Tsabary",`` - Song artist name.
* ``"Title": "Lophophora Williamsii",`` - Song name.
* ``"Length": "2:44",`` - Song length.
* ``"License": "CC BY-NC"`` - Song license.

### Understanding formData records

1. Starting at the beginning, all formData records start with ``__formData|``
2. The middle section is the name of the mod file you are pulling the music from.
3. The last section is the FormID of the specific sound marker record, with the first two digits removed and then all preceding zeros dropped.
4. So for example, the FormID ``0300080C`` will lose the first two digits and become ``00080C``.
5. Then the preceding zeros are dropped and it becomes ``80C``
6. Finally add ``0x`` to the begining of the record ``0x80C`` to indicate that it's in Hex, and you've converted the FormID to a formData record.

## Special Thanks & Attribution

* Sairion for creating Ostim.
* MrNeverLost for creating NL_MCM.
* Dunc001 for flash advice and help.
* You, for reading this whole page.

And finally, and most importantly, the artists who have put their music up for use under [CC BY-NC](https://creativecommons.org/licenses/by-nc/4.0/):

* **DJ Bootsie**
* **Eldad Tsabary**
* **Martinibomb**
* **Nick Chapman**
* **SonnyJim**
* **The Funky Filter**
* **The Lounge King**

# ___You all rock!___
