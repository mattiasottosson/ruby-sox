# Ruby SoX

A Ruby wrapper for the `sox` command line tool to process sound.


## Dependencies

* SoX
* Bash (for process substitution combiner strategy)
* Chromaprint (only to run tests)

### Debian / Ubuntu

```bash
apt-get install sox libchromaprint-dev
```

### Mac

```bash
# One of the following
# Note: chromaprint is not available in MacPorts as of this writing:
sudo port install sox flac && brew install chromaprint
brew install sox flac chromaprint
```

# Usage

Remember that it's a wrapper for `sox` to provide Ruby API.
It's assumed that you know the basics of sound computing theory and how
the `sox` tool works. Otherwise, `man sox` is your good friend.

## Sox::Cmd

Allows you to do everything that the `sox` command does.

Mix 3 files into one (ruby-sox assumes that input files have same rate and number of channels):

```ruby
sox = Sox::Cmd.new(:combine => :mix)
sox.add_input("guitar1.flac")
sox.add_input("guitar2.flac")
sox.add_input("drums.flac")
sox.set_output("hell_rock-n-roll.mp3")
sox.set_effects(:rate => 44100, :channels => 2)
sox.run
```

## Sox::Combiner

Sox::Combiner combines files even if they have different rates or numbers
of channels. Under the hood, it converts the input files into temporary files
to have the same rate and number of channels, and then combines them.

Concatenate:

```ruby
combiner = Sox::Combiner.new('in1.mp3', 'in2.ogg', 'in3.wav', :combine => :concatenate)
combiner.write('out.mp3')
```

Mix 3 files into an MP3 with 2 channels and a rate of 1600:

```ruby
combiner = Sox::Combiner.new('in1.mp3', 'in2.ogg', 'in3.wav', :combine => :mix, :rate => 1600, :channels => 2)
combiner.write('out.mp3')
```

## Run specs

```bash
rake spec
```

## Credits

* [Sergey Potapov](https://github.com/greyblake)

## Copyright

Copyright (c) 2013 TMX Credit.
