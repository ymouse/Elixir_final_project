defmodule Mp3ListTest do
  use ExUnit.Case
  doctest InnerWorkings

  test "listByArtist" do
    IO.puts("listByArtist")
    result = InnerWorkings.listArrangedByArtist(Path.absname("test_dir"))
    assert result == ["Alice Cooper - Welcome 2 My Nightmare - I Am Made Of You", "Dubioza Kolektiv - Dubioza Kolektiv - Be Highirly"]
  end

  test "listByAlbum" do
    IO.puts("listByAlbum")
    result = InnerWorkings.listArrangedByAlbum(Path.absname("test_dir"))
    assert result == ["Dubioza Kolektiv - Dubioza Kolektiv - Be Highirly", "Alice Cooper - Welcome 2 My Nightmare - I Am Made Of You"]
  end

  test "listByTitle" do
    IO.puts("listByTitle")
    result = InnerWorkings.listArrangedByTitle(Path.absname("test_dir"))
    assert result == ["Dubioza Kolektiv - Dubioza Kolektiv - Be Highirly", "Alice Cooper - Welcome 2 My Nightmare - I Am Made Of You"]
  end
end