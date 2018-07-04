defmodule Mp3Reader do
    @moduledoc """
    Reads the tags of mp3's.
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
        mp3_byte_size = (byte_size(binary) - 128)
        << _ :: binary - size(mp3_byte_size), id3_tag :: binary >> = binary
        << "TAG",
            title   :: binary-size(30), 
            artist  :: binary-size(30), 
            album   :: binary-size(30), 
            _    :: binary-size(34), 
            genre :: binary >> = id3_tag
        case tag do
            "artist" -> convertBinaryToString(artist)
            "title" -> convertBinaryToString(title)
            "album" -> convertBinaryToString(album)
            "genre" -> convertBinaryToString(genre)
            "format" -> convertBinaryToString(artist) <> " - " <> convertBinaryToString(album) <> " - " <> convertBinaryToString(title)
            "all" -> [convertBinaryToString(mp3File), convertBinaryToString(artist), convertBinaryToString(album), convertBinaryToString(title)]
        end
    end

    defp convertBinaryToString(binary) do
        Enum.join(Enum.map(to_charlist(binary), fn(x) -> case x do 
            0 -> ""
            _ -> <<x ::utf8>> end end))
    end
end