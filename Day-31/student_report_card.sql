/*
PROBLEM STATEMENT: Given tables represent the marks scored by engineering students.
Create a report to display the following results for each student.
  - Student_id, Student name
  - Total Percentage of all marks
  - Failed subjects (must be comma seperated values in case of multiple failed subjects)
  - Result (if percentage >= 70% then 'First Class', if >= 50% & <=70% then 'Second class', if <=50% then 'Third class' else 'Fail'.
  			The result should be Fail if a students fails in any subject irrespective of the percentage marks)
	
	*** The sequence of subjects in student_marks table match with the sequential id from subjects table.
	*** Students have the option to choose either 4 or 5 subjects only.
*/


select * from students;
select * from student_marks;
select * from subjects;

with studentmarks_cte as (
select student_id, s.name,column1 as subject_code,column2 as marks from student_marks sm
cross join lateral (values('subject1',subject1),('subject2',subject2),('subject3',subject3)
					,('subject4',subject4),('subject5',subject5),('subject6',subject6)) x 
		join students s on s.roll_no = sm.student_id
		where column2 is not null
),
sub_marks as (select subject_code,subject_name,pass_marks from
				(select row_number() over(order by ordinal_position) as rn ,column_name as subject_code
				from information_schema.columns 
				where table_name = 'student_marks' and column_name like 'subject%') a 
				JOIN (select row_number() over(order by id) as rn, name as subject_name,pass_marks
				from subjects) b on a.rn = b.rn)
,marks_agg as (
				select student_id,name,round(avg(marks),2) as percentage_marks,
				string_agg(CASE when marks >= pass_marks then null else subject_name end,',') as failed_subjects 
				from studentmarks_cte sm1 
				join sub_marks st on st.subject_code =sm1.subject_code
				group by student_id,name)
select student_id,name,percentage_marks,coalesce(failed_subjects,'-') as failed_subjects,
case when failed_subjects is not null then 'Fail' 
	 when percentage_marks >= 70 then 'First Class'
	 when percentage_marks between 50 and 70 then 'Second Class'
	 when percentage_marks <50 then 'Third class' end as result
from marks_agg
group by student_id,name,percentage_marks,failed_subjects
order by student_id;