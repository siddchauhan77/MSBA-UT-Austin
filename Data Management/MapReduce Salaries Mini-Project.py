#Import necessary Packages

from mrjob.job import MRJob
from mrjob.step import MRStep

#Define functions to use

class Top10(MRJob):

    def steps(self):
          return [
              MRStep(mapper=self.mapper_get_salaries,
                  reducer=self.reduce_count_sals),
              MRStep(mapper=self.mapper_salary_value, reducer = self.reducer_to_top_10)]

# Mapper 1

    def mapper_get_salaries(self, key, line): #Mapper
        salaries = line.split()
        for salary in salaries:
            yield salary, 1

# Reducer 1
    def reduce_count_sals(self, salary, occurrences): # get the unique salaries
        yield salary, sum(occurrences)

# Mapper 2
    def mapper_salary_value(self, salary, total):
      yield None, int(salary) #Switching value with key

# Reducer 2
    def reducer_to_top_10(self,key,salaries):
      self.top_10_sals = [0]

      for salary in salaries:

        if salary > min(self.top_10_sals) or len(self.top_10_sals) < 10:
          if len(self.top_10_sals) == 10:
            self.top_10_sals.remove(min(self.top_10_sals))
          self.top_10_sals.append(salary)

      for salary in self.top_10_sals:
        yield None, salary
#Output
if __name__ == '__main__':
  #Top10.run()
  otp = Top10.run()
  print(otp)





#End of Code
