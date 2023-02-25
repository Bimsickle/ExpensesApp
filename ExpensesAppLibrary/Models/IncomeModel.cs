using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpensesAppLibrary.Models
{
    public class IncomeModel
    {
        public int Id { get; set; }
        public string Description { get; set; }
        public int CostAccountID { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public bool Active { get; set; }
        public decimal SalaryRate { get; set; }
        public int SalaryTaxID { get; set; }
        public bool TaxHeld { get; set; }
        public int SalaryCycleID { get; set; }
        public decimal StandardWeekHours { get; set; }
        public int PayCycle { get; set; }
        public int PayCycleInrem { get; set; }
        public DateTime PayStartDate { get; set; }
        public int PayDayOfWeek { get; set; }
        public decimal WeekendRate { get; set; }
        public decimal HolidayRate { get; set; }
        public decimal EveningRate { get; set; }
        public decimal PaidLeaveHoursAnnual { get; set; }
        public int BankAccountID { get; set; }
        public bool HoldTaxStudentLoan { get; set; }
        public DateTime LastPayDate { get; set; }
        public decimal LastPayAmount { get; set; }
        
        
        public decimal DefaultPayAmount()
        {        
            // Calculate Hourly Rate
            decimal[] rates = { SalaryRate, 
                                (SalaryRate/StandardWeekHours)*5, 
                                SalaryRate / StandardWeekHours,
                                SalaryRate / StandardWeekHours / 2, 
                                (SalaryRate * 12) /52/ StandardWeekHours,
                                SalaryRate /13/ StandardWeekHours,
                                SalaryRate /52/ StandardWeekHours
                                };
           
            // Calculate Pay rate at pay cycle
            decimal[] payrate = { 1, StandardWeekHours / 5, StandardWeekHours, StandardWeekHours * 2, (StandardWeekHours * 52) / 12, (StandardWeekHours * 52) / 4, (StandardWeekHours * 52) };
            
            return rates[SalaryCycleID - 1] * payrate[PayCycle - 1];
        }
    }
}
