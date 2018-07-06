defmodule Interactor do

  @moduledoc """
  This module contains the entire communication between the user and the InnerWorkings module, which executes whatever command is needed.
  """

  @doc """
  In run we check for the directory and communicate with the user until he enters the code for exit - 0.
  """
  def run do
    dir = getLastDirectory() # check if we have a directory written down in a file
    directory = switchDir(dir) # we check if the user wants to change the directory or request one
    writeDownDirectory(directory) # write down the actual directory in the file
    task = Task.async(fn -> InnerWorkings.refreshRepeatedly(directory) end)
    printMenu()
    send(task.pid, {:ok, "start"})
    innerRun(1, task)
  end

  # cancels the task for the refresh and closes the app
  defp innerRun(0, task) do
    send(task.pid, {:ok, "stop"})
    Task.await(task, 30000)
    fn -> :closed end
  end

  defp innerRun(_, task) do
    readInput(task)
  end

  # writes down the given directory to a file
  defp writeDownDirectory(directory) do
    if File.exists?("directory") do
      File.rm!("directory")
    end
    File.write("directory", directory)
  end

  # if we have no directory set yet, we request one from the user, if we have one, we ask the user if that is the one they want
  defp switchDir("") do
    dir = IO.gets("Please enter an absolute path to your mp3 collection: ")
    String.trim(dir, "\n")
  end
  defp switchDir(dir) do
    IO.puts("Last used directory was " <> dir)
    IO.puts("Would you like to change the directory? y/n")
    answer = String.trim(IO.gets(""), "\n")
    if answer == "y" do
      newDir = IO.gets("Please enter a new absolute path: ")
      String.trim(newDir, "\n")
    else
      dir
    end
  end

  # reads the last set directory from the file. if the file does not exist or is corrupted, we just return an empty string.
  defp getLastDirectory do
    file = File.read("directory")
    case file do
      {:ok, dir} -> String.trim(dir, "\n")
      {:error, _} -> ""
    end
  end

  # prints the initial menu for the user
  defp printMenu do
    IO.puts("Now that you have set up your directory, what would you like to do:\n
    1. List all songs, arranged by artist;
    2. List all songs, arranged by title;
    3. List all songs, arranged by album;
    4. Search for artist;
    5. Search for song;
    6. Search for album;
    7. Rename all;
    8. Rename all from artist;
    9. Rename all from album;
   10. Rename all with title;
    0. Exit
    ")
  end

  # reads commands from the user and passes them down to innerRun which looks at whether the user has exited or not
  defp readInput(task) do
    {answer, _} = IO.gets("Command: ") |> Integer.parse 
    executeInput(answer)
    innerRun(answer, task)
  end

  # executes the command, given by the user
  defp executeInput(0), do: _ = ""
  defp executeInput(1) do
    tmp = Task.async(fn -> InnerWorkings.listArrangedByArtist(getLastDirectory()) end)
    Task.await(tmp, 90000)
  end
  defp executeInput(2) do
    tmp = Task.async(fn -> InnerWorkings.listArrangedByTitle(getLastDirectory()) end)
    Task.await(tmp, 90000)
  end
  defp executeInput(3) do
    tmp = Task.async(fn -> InnerWorkings.listArrangedByAlbum(getLastDirectory()) end)
    Task.await(tmp, 90000)
  end
  defp executeInput(4) do
    search = String.trim(IO.gets("Artist to look up: "), "\n")
    tmp = Task.async(fn -> InnerWorkings.searchByArtist(getLastDirectory(), search) end)
    Task.await(tmp, 90000)
  end
  defp executeInput(5) do
    search = String.trim(IO.gets("Title to look up: "), "\n")
    tmp = Task.async(fn -> InnerWorkings.searchByTitle(getLastDirectory(), search) end)
    Task.await(tmp, 90000)
  end
  defp executeInput(6) do
    search = String.trim(IO.gets("Album to look up: "), "\n")
    tmp = Task.async(fn -> InnerWorkings.searchByAlbum(getLastDirectory(), search) end)
    Task.await(tmp, 90000)
  end
  defp executeInput(7) do
    IO.puts("Please, choose a name pattern:\n
    1. <artist> - <title>;
    2. <artist>(<album>) - <title>;
    3. <title>
    ")
    {answer, _} = IO.gets("Pattern: ") |> Integer.parse 
    tmp = Task.async(fn -> InnerWorkings.renameAll(getLastDirectory(), answer) end)
    Task.await(tmp, 90000)
  end
  defp executeInput(8) do
    IO.puts("Please, choose a name pattern:\n
    1. <artist> - <title>;
    2. <artist>(<album>) - <title>;
    3. <title>
    ")
    {pattern, _} = IO.gets("Pattern: ") |> Integer.parse 
    artist = String.trim(IO.gets("Artist: "), "\n")
    tmp = Task.async(fn -> InnerWorkings.renameByArtist(getLastDirectory(), artist, pattern) end)
    Task.await(tmp, 90000)
  end
  defp executeInput(9) do
    IO.puts("Please, choose a name pattern:\n
    1. <artist> - <title>;
    2. <artist>(<album>) - <title>;
    3. <title>
    ")
    {pattern, _} = IO.gets("Pattern: ") |> Integer.parse 
    album = String.trim(IO.gets("Album: "), "\n")
    tmp = Task.async(fn -> InnerWorkings.renameByAlbum(getLastDirectory(), album, pattern) end)
    Task.await(tmp, 90000)
  end
  defp executeInput(10) do
    IO.puts("Please, choose a name pattern:\n
    1. <artist> - <title>;
    2. <artist>(<album>) - <title>;
    3. <title>
    ")
    {pattern, _} = IO.gets("Pattern: ") |> Integer.parse 
    title = String.trim(IO.gets("Title: "), "\n")
    tmp = Task.async(fn -> InnerWorkings.renameByTitle(getLastDirectory(), title, pattern) end)
    Task.await(tmp, 90000)
  end
  defp executeInput(_) do
    IO.puts("INVALID COMMAND!!! TRY AGAIN!!!")
  end
end