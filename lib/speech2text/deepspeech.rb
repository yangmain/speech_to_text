# Set encoding to utf-8
# encoding: UTF-8
#
# BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
#
# Copyright (c) 2019 BigBlueButton Inc. and by respective authors (see below).
#
require_relative "util.rb"

module Speech2Text
	module BBBDeepspeech
    include Util

    def create_deepspeech_array(data)
    	i=0
    	myarray = []
    	while i<data["words"].length
    		myarray.push(data["words"][i]["time"].to_f)
    		if i == data["words"].length - 1
    			endtime = data["file"]["duration"].to_f
    		else
    			endtime =  data["words"][i+1]["time"].to_f
    		end
    		myarray.push(endtime)
    		myarray.push(data["words"][i]["word"])
    		i = i+1
    	end
    	return myarray
    end

    def BBBDeepspeechCaptions(published_files, recordID)
     require 'json'
     video_to_audio_command = "ffmpeg -i #{published_files}/#{recordID}/video/video.mp4 #{published_files}/#{recordID}/#{recordID}.wav"
     system(video_to_audio_command)
     jsonfile_path = "#{published_files}/#{recordID}/#{recordID}.json"
     deepspeech_command = "./deepspeech --model models/output_graph.pbmm --alphabet models/alphabet.txt --lm models/lm.binary --trie models/trie -e --audio #{published_files}/#{recordID}/#{recordID}.wav > #{jsonfile_path}"
     system("#{deepspeech_command}")
     file = File.open(jsonfile_path,"r")
     data = JSON.load(file)
     deepspeech_array = create_deepspeech_array(data)
     Util.write_to_webvtt deepspeech_array
    end
  end
end
