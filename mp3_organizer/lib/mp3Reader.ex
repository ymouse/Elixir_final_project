defmodule Mp3Reader do
    @moduledoc """
    Reads the tags of mp3's.
    Logic for reading the tags from: http://benjamintan.io/blog/2014/06/10/elixir-bit-syntax-and-id3/
    """

    @doc """
    Reads and returns all of the tags of songs in a given list of absolute paths.
    """
    def readMultipleMp3s([], _), do: []
    def readMultipleMp3s([head | tail], tag) do 
        [readMp3Tag(head, tag)] ++ readMultipleMp3s(tail, tag)
    end

    defp readMp3Tag(mp3File, tag) do
        binary = File.read!(mp3File)
        audio_size = (byte_size(binary) - 128)
        << _ :: binary - size(audio_size), id3_tag :: binary >> = binary
        if (match?(<< "TAG", title :: binary-size(30), artist :: binary-size(30), album :: binary-size(30), year :: binary-size(4), comment :: binary-size(30), rest :: binary >>, id3_tag)) do
            << "TAG",
                title   :: binary-size(30), 
                artist  :: binary-size(30), 
                album   :: binary-size(30), 
                year    :: binary-size(4), 
                comment :: binary-size(30), 
                rest   :: binary >> = id3_tag
            case tag do
                "artist" -> convertBinaryToString(artist)
                "title" -> convertBinaryToString(title)
                "album" -> convertBinaryToString(album)
                "format" -> convertBinaryToString(artist) <> " - " <> convertBinaryToString(album) <> " - " <> convertBinaryToString(title)
                "all" -> [convertBinaryToString(mp3File), convertBinaryToString(artist), convertBinaryToString(album), convertBinaryToString(title)]
            end
        else
            audio_size = (byte_size(binary) - 130)
            << _ :: binary - size(audio_size), id3_tag :: binary >> = binary
            << "TAG",
                title   :: binary-size(30), 
                artist  :: binary-size(30), 
                album   :: binary-size(30), 
                year    :: binary-size(4), 
                comment :: binary-size(28), 
                rest   :: binary >> = id3_tag
            case tag do
                "artist" -> convertBinaryToString(artist)
                "title" -> convertBinaryToString(title)
                "album" -> convertBinaryToString(album)
                "format" -> convertBinaryToString(artist) <> " - " <> convertBinaryToString(album) <> " - " <> convertBinaryToString(title)
                "all" -> [convertBinaryToString(mp3File), convertBinaryToString(artist), convertBinaryToString(album), convertBinaryToString(title)]
            end
        end
    end

    defp convertBinaryToString(binary) do
        if String.valid?(binary) do
            String. trim(Enum.join(Enum.map(to_charlist(binary), fn(x) -> case x do 
                            0 -> ""
                            _ -> <<x ::utf8>> end end)), " ")
        else
            ""
        end
    end
end