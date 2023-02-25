using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpensesAppLibrary.Models
{
    public class RecurringExpenseModel
    {
        public int Id { get; set; }
        public string Description { get; set; }
        public int Active { get; set; }
        public DateTime DateStart { get; set; }
        public DateTime DateEnd { get; set; }
        public int Instances { get; set; }   
        public int CostAccountID { get; set; }
        public int DefaultPayAccountID { get; set; }
        public int FrequencyCycleID { get; set; }
        public int FrequencyCycleIncrem { get; set; } = 1;
        public decimal Amount { get; set; }
        public bool Increase { get; set; } = false;
        public int IncreaseCycleID { get; set; }
        public int IncreaseCycleIncrem { get; set; }
        public DateTime IncreaseDate { get; set; }
        public int IncreaseType { get; set; }
        public decimal IncreaseAmount { get; set; }
        public DateTime LatestRecord { get; set; }

    }
}
