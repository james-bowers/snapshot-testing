defmodule SnapshotTestingTest do
  use ExUnit.Case
  import SnapshotTesting

  snapshot_test "first snapshot test" do
    "foo"
  end

  snapshot_test "second snapshot test" do
"""
foo
bar
bye
hello
"""
  end
end
