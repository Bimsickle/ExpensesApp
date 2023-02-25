using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpensesAppLibrary.Models
{
    public class CostAccountModel
    {
        public int Id { get; set; }
        public string Description { get; set; }
        public int CostCentre { get; set; }
        public bool Edit { get; set; }
        public bool Active { get; set; }
        public int CreditDebit { get; set; }
    }
}
