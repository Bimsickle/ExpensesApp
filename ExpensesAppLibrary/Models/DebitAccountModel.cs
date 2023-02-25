
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpensesAppLibrary.Models
{
    public class DebitAccountModel
    {
        public string Description { get; set; }
        public string Bank { get; set; }
        public DateTime OpeningDate { get; set; }
        public decimal InterestRate { get; set; }
        public decimal Fee { get; set; }
        public int FeeCycleID { get; set; }
        public int FreeCycleIncremum { get; set; }
        public int CostAccountID { get; set; }
    }
}
