# Ruby SoX

Ruby wrapper for `sox` command line tool to process sound.


## Dependencies

* Sox
* Bash (for process substitution combiner strategy)

### Debian / Ubuntu

```
apt-get install sox
```

# Usage

First at all it's a wrapper for `sox` to provide Ruby API.
I assume you know the basic of sound computing theory and how `sox` tool works.
Otherwise `man sox` is your good friend.

## Sox::Cmd

Allows to do everything that `sox` command does.

Mix 3 files into one (we assume input files have same rate and number of channels):
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

Sox::Combiner combines files even if they have different rate or number
of channels. Underhood it converts input files into temporary files to have
same rate and number of channels and then combines them.

Concatenate:
```ruby
combiner = Sox::Combiner.new('in1.mp3', 'in2.ogg', 'in3.wav', :combine => :concatenate)
combiner.write('out.mp3')
```

Mix 3 files into mp3 with 2 channels and rate 1600:
```ruby
combiner = Sox::Combiner.new('in1.mp3', 'in2.ogg', 'in3.wav', :combine => :mix, :rate => 1600, :channels => 2)
combiner.write('out.mp3')
```

## Run specs

```
rake spec
```

## Credits

* [Sergey Potapov](https://github.com/greyblake)

## Copyright

Copyright (c) 2013 TMX Credit.
