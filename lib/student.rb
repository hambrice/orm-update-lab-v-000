require_relative "../config/environment.rb"

class Student
attr_accessor :id, :name, :grade

  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end
  
  def self.create_table 
    sql = "CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER)"
      
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE students"
     DB[:conn].execute(sql)
   end
   
   def save
    if self.id
      self.update
    else
    sql = "INSERT INTO students (name, grade) VALUES (?,?)"
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
    end
    
    def self.create(name, grade) 
      student = self.new(name, grade)
      student.save
      student 
    end

    def self.new_from_db(row)
      id = row[0]
      name = row[1]
      grade = row[2]
      student = self.new(name, grade, id)

    end
    
    def self.find_by_name(name)
      sql = "SELECT * FROM students WHERE name = ?"
      self.new_from_db(DB[:conn].execute(sql, name).first)
    end
    def update
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
      DB[:conn].execute(sql, self.name,self.grade,self.id)
    end
end