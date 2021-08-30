select s.name "Student", c.name "Course"
from student s, bridge b, course c
where b.sid = s.sid and b.cid = c.cid 
