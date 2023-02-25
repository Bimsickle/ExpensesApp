using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpensesAppLibrary.Models
{
    public class LoanModel
    {
        public int Id { get; set; }
        public bool Active { get; set; }
        public bool ReDraw { get; set; }
        public string Description { get; set; }
        public string Bank { get; set; }
        public DateTime OpeningDate { get; set; }
        public DateTime ClosingDate { get; set; }
        public decimal LoanAmount { get; set; }
        public decimal SetupFee { get; set; }
        public decimal RepaymentAmount { get; set; }
        public int RepaymentCycleID { get; set; }
        public decimal InterestRate { get; set; }
        public bool InterestFixed { get; set; }
        public decimal Fee { get; set; }
        public int FeeCycleID { get; set; }
        public int FeeCycleIncrem { get; set; }
        public int CostAccountID { get; set; }
        public int InterestCostAccountID { get; set; }
    }
}