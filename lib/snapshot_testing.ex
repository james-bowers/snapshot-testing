defmodule SnapshotTesting do
  def test_name_path(test_name) do
    test_name =
      test_name
      |> String.replace("/", "-")
      |> String.replace(" ", "_")

    "__snapshots__/#{__MODULE__}_#{test_name}"
  end

  def read_expected_result(test_name) do
    with file_path <- test_name_path(test_name), true <- File.exists?(file_path) do
      File.read(file_path)
    else
      false -> :no_result_recorded
    end
  end

  def save_result(test_name, actual_result) do
    path = test_name_path(test_name)
    File.mkdir("__snapshots__")
    File.write!(path, actual_result)
  end

  defmacro snapshot_test(test_name, do: yield) do
    quote do
      test unquote(test_name) do
        actual_result = unquote(yield)

        with {:ok, expected_result} <- read_expected_result(unquote(test_name)) do
          assert actual_result == expected_result
        else
          :no_result_recorded ->
            save_result(unquote(test_name), actual_result)
        end
      end
    end
  end
end
