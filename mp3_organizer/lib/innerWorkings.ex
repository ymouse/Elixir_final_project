defmodule InnerWorkings do
    @mp3 "mp3s"
    @moduledoc """
    This module describes the inner workings of the application. 
    It includes the refresh cycle, list functions and search functions.
    """
    
    @doc """
    Looks up the directory once every 5 seconds. It is run in the background and stopped when the app is stopped.
    """
    def refreshRepeatedly(dir) do
        receive do
            {:ok, "stop"} -> File.rm!(@mp3)
            {:ok, "start"} -> refreshOnce(dir)
                              Process.sleep(5000)
                              send(self(), {:ok, "start"})
                              refreshRepeatedly(dir)
        end
    end

    @doc """
    Lists all of the songs in the directory arranged by artist.
    """
    def listArrangedByArtist(dir) do
        tags = getFullMp3ListFromFile(dir)
        sorted = Enum.sort(tags, fn(x,y) -> [_, a | _] = x 
                                            [_, b | _] = y 
                                            a < b end)
        customPrint(sorted)
    end

    @doc """
    Lists all of the songs in the directory arranged by album.
    """
    def listArrangedByAlbum(dir) do
        tags = getFullMp3ListFromFile(dir)
        sorted = Enum.sort(tags, fn(x,y) -> [_, _, a | _] = x 
                                            [_, _, b | _] = y 
                                            a < b end)
        customPrint(sorted)
    end

    @doc """
    Lists all of the songs in the directory arranged by title.
    """
    def listArrangedByTitle(dir) do
        tags = getFullMp3ListFromFile(dir)
        sorted = Enum.sort(tags, fn(x,y) -> [_, _, _, a | _] = x 
                                            [_, _, _, b | _] = y 
                                            a < b end)
        customPrint(sorted)
    end

    @doc """
    Looks up an artist in the directory and lists all of their songs.
    """
    def searchByArtist(dir, search) do
        tags = getFullMp3ListFromFile(dir)
        filtered = Enum.filter(tags, fn(x) -> [_, a | _] = x 
                                              a =~ search end)
        customPrint(filtered)
    end

    @doc """
    Looks up an album in the directory and lists all of the songs in it.
    """
    def searchByAlbum(dir, search) do
        tags = getFullMp3ListFromFile(dir)
        filtered = Enum.filter(tags, fn(x) -> [_, _, a | _] = x 
                                              a =~ search end)
        customPrint(filtered)
    end

    @doc """
    Looks up a title in the directory and lists all of the songs with that title.
    """
    def searchByTitle(dir, search) do
        tags = getFullMp3ListFromFile(dir)
        filtered = Enum.filter(tags, fn(x) -> [_, _, _, a | _] = x 
                                              a =~ search end)
        customPrint(filtered)
    end

    defp customPrint([]), do: IO.puts("\n")
    defp customPrint([[_, artist, album, title] | tail]) do
        IO.puts(artist <> ": " <> album <> " - " <> title)
        customPrint(tail)
    end

    defp compileStringForMp3sFile([]), do: ""
    defp compileStringForMp3sFile([head | tail]) do
        [path, artist, album, title] = head
        path <> "#" <> artist <> "#" <> album <> "#" <> title <> "@" <> compileStringForMp3sFile(tail)
    end

    defp refreshOnce(dir) do
        files = DirReader.readPathRecursively(dir)
        files = getOnlyMp3Files(files)
        filesWithTagsRead = Mp3Reader.readMultipleMp3s(files, "all")
        if File.exists?(@mp3) do
            File.rm!(@mp3)
        end
        File.write(@mp3, compileStringForMp3sFile(filesWithTagsRead))
        files
    end

    defp getFullMp3ListFromFile(dir) do
        refreshOnce(dir)
        tags = Enum.map(String.split(File.read!(@mp3), "@"), fn(x) -> String.split(x, "#") end)
        Enum.filter(tags, fn(x) -> length(x) == 4 end)
    end
    
    defp getOnlyMp3Files(files) when is_list(files), do: Enum.filter(files, fn(x) -> String.slice(x, -4..-1) == ".mp3" end)
end