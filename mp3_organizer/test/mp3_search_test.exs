defmodule Mp3SearchTest do
  use ExUnit.Case

  test "searchByArtist" do
    result = InnerWorkings.searchByArtist(Path.absname("test_dir"), "Alice Cooper")
    assert result == [["Alice Cooper", "Welcome 2 My Nightmare", "I Am Made Of You"]]
  end

  test "searchByAlbum" do
    result = InnerWorkings.searchByAlbum(Path.absname("test_dir"), "Dubioza Kolektiv")
    assert result == [["Dubioza Kolektiv", "Dubioza Kolektiv", "Be Highirly"]]
  end

  test "searchByTitle" do
    result = InnerWorkings.searchByTitle(Path.absname("test_dir"), "Be Highirly")
    assert result == [["Dubioza Kolektiv", "Dubioza Kolektiv", "Be Highirly"]]
  end
end