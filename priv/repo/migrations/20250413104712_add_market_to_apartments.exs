defmodule Ukio.Repo.Migrations.AddMarketToApartments do
  use Ecto.Migration

  def change do
    alter table(:apartments) do
      add :market, :string, default: "default"
    end
  end
end
