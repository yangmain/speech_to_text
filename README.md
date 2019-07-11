# SpeechToText

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/speech_to_text`. To experiment with that code, run `bin/console` for an interactive prompt.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'speech_to_text'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install speech_to_text

## Usage
BigBlueButton provides various captions services.
Use following command to access the different services.
You have to convert video to audio using following command

```ruby
SpeechToText::Util.video_to_audio(published_files,recordID,service)
```
where
published_files = <path to your published files>
recordID = <your recordID folder> (should be inside published_files)
service = <google or ibm or mozilla_deepspeech or speechmatics>


Then based on the service you can execute one of the following command.

if service = ibm, execute following commands

```ruby
params = SpeechToText::IbmWatsonS2T.create_job(published_files,recordID,apiKey)
data = SpeechToText::IbmWatsonS2T.check_job(params)
myarray = SpeechToText::IbmWatsonS2T.create_array_watson(data["results"][0])
SpeechToText::Util.write_to_webvtt(published_files,recordID,myarray)
```

if service = google, execute following commands
if you don't have worker then execute following command only one time but if you have multiple workers then you need to set environment for each worker.
Execute following command in order to set environment
```ruby
SpeechToText::GoogleS2T.set_environment("auth_file")
```
After setting environment, execute following commands to get google transcription

```ruby
file = SpeechToText::GoogleS2T.google_storage("published_file","recordID","bucket_name")
params = SpeechToText::GoogleS2T.create_job("recordID","bucket_name")
data = SpeechToText::GoogleS2T.check_job(params)
myarray = SpeechToText::GoogleS2T.create_array_google(data["results"])
SpeechToText::Util.write_to_webvtt("published_file","recordID",myarray)
file.delete
```

if service = mozilla_deepspeech
```ruby
SpeechToText::MozillaDeepspeechS2T.mozilla_speech_to_text(published_files,recordID,model_path)
```

if service = speechmatics
```ruby
SpeechToText::SpeechmaticsS2T.speechmatics_speech_to_text(published_files,recordID,userID, apiKey)
```

NOTE:
you can use this gemfile only if you have following directory structure.
{published_files_path}/{recordID}/video
where published_files_path could be any path
and recordID could be any folder and should be inside the published_files_path.
Your recordID folder will contain "video" folder which has video.mp4 file inside "video" folder.
Full videopath: {published_files_path}/{recordID}/video/video.mp4

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

NOTE : After your changes execute this commands
1. Build your gem file : 'gem build speech_to_text.gemspec'
2. Install your gem file : 'gem install speech_to_text-0.1.1.gem'                  //replace the version number
3. 'bundle install'                                                                //optional command

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/speech_to_text.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
