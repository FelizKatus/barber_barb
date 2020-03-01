class CreateBarbers < ActiveRecord::Migration[6.0]
  def change
    create_table :barbers do |t|
      t.text :name

      t.timestamps
    end

    Barber.create :name => 'Alberto Cerdán'
    Barber.create :name => 'Josep Pons'
    Barber.create :name => 'Moncho Moreno'
    Barber.create :name => 'Lorena Morlote'
    Barber.create :name => 'Raffel Pages'
    Barber.create :name => 'Amparo Fernández'
    Barber.create :name => 'Olga García'
  end
end
