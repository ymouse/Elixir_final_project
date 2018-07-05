defmodule InnerWorkings do
    @moduledoc """
    This module describes the inner workings of the application. 
    It includes the refresh cycle, list functions and search functions.
    """
    
    @doc """
    Looks up the directory once every 30 seconds. Meant to be run in the background. Currently not called.
    """
    def refreshRepeatedly(dir) do
        files = refreshOnce(dir)
        Process.sleep(30000)
        refreshRepeatedly(dir)
    end

    @doc """
    Lists all of the songs in the directory arranged by artist.
    """
    def listArrangedByArtist(dir) do
        tags = Mp3Reader.readMultipleMp3s(getOnlyMp3Files(refreshOnce(dir)), "all")
        sorted = Enum.sort(tags, fn(x,y) -> [_, a | _] = x 
                                            [_, b | _] = y 
                                            a < b end)
        sortedFormatted = Mp3Reader.readMultipleMp3s(Enum.map(sorted, fn(x) -> head(x) end), "format")
        customPrint(sortedFormatted)
        sortedFormatted
    end

    @doc """
    Lists all of the songs in the directory arranged by album.
    """
    def listArrangedByAlbum(dir) do
        tags = Mp3Reader.readMultipleMp3s(getOnlyMp3Files(refreshOnce(dir)), "all")
        sorted = Enum.sort(tags, fn(x,y) -> [_, _, a | _] = x 
                                            [_, _, b | _] = y 
                                            a < b end)
        sortedFormatted = Mp3Reader.readMultipleMp3s(Enum.map(sorted, fn(x) -> head(x) end), "format")
        customPrint(sortedFormatted)
        sortedFormatted
    end

    @doc """
    Lists all of the songs in the directory arranged by title.
    """
    def listArrangedByTitle(dir) do
        tags = Mp3Reader.readMultipleMp3s(getOnlyMp3Files(refreshOnce(dir)), "all")
        sorted = Enum.sort(tags, fn(x,y) -> [_, _, _, a | _] = x 
                                            [_, _, _, b | _] = y 
                                            a < b end)
        sortedFormatted = Mp3Reader.readMultipleMp3s(Enum.map(sorted, fn(x) -> head(x) end), "format")
        customPrint(sortedFormatted)
        sortedFormatted
    end

    @doc """
    Looks up an artist in the directory and lists all of their songs.
    """
    def searchByArtist(dir, search) do
        tags = Mp3Reader.readMultipleMp3s(getOnlyMp3Files(refreshOnce(dir)), "all")
        sorted = Enum.filter(tags, fn(x) -> [_, a | _] = x 
                                            a == search end)
        filteredFormatted = Mp3Reader.readMultipleMp3s(Enum.map(sorted, fn(x) -> head(x) end), "format")
        customPrint(filteredFormatted)
        filteredFormatted
    end

    @doc """
    Looks up an album in the directory and lists all of the songs in it.
    """
    def searchByAlbum(dir, search) do
        tags = Mp3Reader.readMultipleMp3s(getOnlyMp3Files(refreshOnce(dir)), "all")
        sorted = Enum.filter(tags, fn(x) -> [_, _, a | _] = x 
                                            a == search end)
        filteredFormatted = Mp3Reader.readMultipleMp3s(Enum.map(sorted, fn(x) -> head(x) end), "format")
        customPrint(filteredFormatted)
        filteredFormatted
    end

    @doc """
    Looks up a title in the directory and lists all of the songs with that title.
    """
    def searchByTitle(dir, search) do
        tags = Mp3Reader.readMultipleMp3s(getOnlyMp3Files(refreshOnce(dir)), "all")
        sorted = Enum.filter(tags, fn(x) -> [_, _, _, a | _] = x 
                                            a == search end)
        filteredFormatted = Mp3Reader.readMultipleMp3s(Enum.map(sorted, fn(x) -> head(x) end), "format")
        customPrint(filteredFormatted)
        filteredFormatted
    end

    defp customPrint([]), do: IO.puts("\n")
    defp customPrint([head | tail]) do
        IO.puts(head)
        customPrint(tail)
    end

    defp head([h|_]), do: h
    defp refreshOnce(dir), do: DirReader.readPathRecursively(dir)
    defp getOnlyMp3Files(files) when is_list(files), do: Enum.filter(files, fn(x) -> String.slice(x, -4..-1) == ".mp3" end)
end