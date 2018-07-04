defmodule DirReader do

    @moduledoc """
    This module is for reading files from a selected directory
    """

    @doc """
    Reads the directory directly.

    Returns a list of the files with the path, or mrpints a message that it failed and returns an empty list.

    To test: create a directory you know the contents of. Try it with a relative and an absolute path.
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

    To test: create a directory with multiple levels of subdirectories you know the contents of. Try it with a relative and an absolute path.
    """

    def readPathRecursively(path) do
        allFiles = readPath(path)
        subFolders = getOnlyFolders(allFiles)
        Enum.uniq(allFiles ++ readSubFolders(subFolders))
    end

    defp readSubFolders([]), do: []
    defp readSubFolders([head | tail]) do
        filesRead = File.ls(head)
        case filesRead do
            {:ok, _} -> Enum.map(File.ls!(head), fn(x) -> head <> "/" <> x end) ++ readPathRecursively(head) ++ readSubFolders(tail)
            {:error, _} -> logFailedFolderRead(head) ++ readSubFolders(tail)
        end
    end

    defp logFailedFolderRead(path) do
        IO.puts("Failed to read folder \"" <> path <> "\"!!!!!")
        []
    end
    defp getOnlyFiles(paths) when is_list(paths), do: Enum.filter(paths, fn(x) -> !File.dir?(x) end)
    defp getOnlyFolders(paths) when is_list(paths), do: Enum.filter(paths, fn(x) -> File.dir?(x) end)
end