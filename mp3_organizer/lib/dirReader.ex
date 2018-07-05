defmodule DirReader do

    @moduledoc """
    This module is for reading files from a selected directory
    """

    @doc """
    Reads the directory directly.

    Returns a list of the files with the path, or mrpints a message that it failed and returns an empty list.

    Example:
        iex> DirReader.readPath("../test_dir")
        ["../test_dir/Alice Cooper", "../test_dir/Dubioza Kolektiv"]
    """

    def readPath(path) do
        filesRead = File.ls(path)
        case filesRead do
            {:ok, _} -> Enum.map(File.ls!(path), fn(x) -> path <> "/" <> x end)
            {:error, _} -> logFailedFolderRead(path)
        end
    end

    @doc """
    Reads a directory in depth as deep as possible and returns a list of all of the files and folders in it.

    Example:
        iex> DirReader.readPathRecursively("../test_dir")
        ["../test_dir/Alice Cooper", "../test_dir/Dubioza Kolektiv",
        "../test_dir/Alice Cooper/I Am Made Of You.mp3",
        "../test_dir/Dubioza Kolektiv/2004 - Dubioza Kolektiv",
        "../test_dir/Dubioza Kolektiv/2004 - Dubioza Kolektiv/Be Highirly.mp3"]
    """

    def readPathRecursively(path) do
        allFiles = readPath(path)
        subFolders = Enum.filter(allFiles, fn(x) -> File.dir?(x) end)
        Enum.uniq(allFiles ++ readSubFolders(subFolders))
    end

    # takes a list of paths and reads all of those as well as their subfolders.
    defp readSubFolders([]), do: []
    defp readSubFolders([head | tail]) do
        filesRead = File.ls(head)
        case filesRead do
            {:ok, _} -> Enum.map(File.ls!(head), fn(x) -> head <> "/" <> x end) ++ readPathRecursively(head) ++ readSubFolders(tail)
            {:error, _} -> logFailedFolderRead(head) ++ readSubFolders(tail)
        end
    end

    # if we fail to read a directory, we put a message on the console and return a [] so as to be able to continue
    defp logFailedFolderRead(path) do
        IO.puts("Failed to read folder \"" <> path <> "\"!!!!!")
        []
    end
end