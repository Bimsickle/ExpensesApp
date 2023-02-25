using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpensesAppLibrary.Models
{
    public class Superannuation
    {
        public int Id { get; set; }
        public string Description { get; set; }
        public int SuperAccount { get; set; }
        public int IncomeAccount { get; set; }
        public int InterestAccount { get; set; }
        public int ExpenseAccount { get; set; }
        public bool AccountStatus { get; set; }
    }
}
