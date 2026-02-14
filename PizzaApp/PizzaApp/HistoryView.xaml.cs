using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using static PizzaApp.CartView;

namespace PizzaApp
{
    /// <summary>
    /// Логика взаимодействия для HistoryView.xaml
    /// </summary>
    public partial class HistoryView : UserControl //История заказов (является usercontrol окна пользователя)
    {

        public PizzaTestEntities _dbContext;
        public ObservableCollection<OrdersDisplayItems> OrdersItems { get; set; } = new ObservableCollection<OrdersDisplayItems>();

        public HistoryView()
        {
            InitializeComponent();
            DataContext = this;
        }
        public void InitializeContext(PizzaTestEntities context)
        {
            _dbContext = context;
            OrdersItems.Clear();
           // IsEmpty();
            LoadData();
        }

        public void LoadData()
        {
            var items = _dbContext.Orders.Where(c => c.id_user == MainWindow.CurrentUserId && c.stat > 3).OrderByDescending(c => c.dateorder); 
            //Статика не очень хорошо, на интерфейсы не успел переделать(

            foreach (var item in items)
            {
                OrdersItems.Add(new OrdersDisplayItems
                {
                    DbEntity = item, 
                    Id = item.id,
                    DateOrder = (DateTime)item.dateorder,
                    TotalPrice = (int)item.total,
                    Status = item.Statuses.descr,
                    StatBrush = SetBrush(item.stat)
                });
            }

           
        }

        public Brush SetBrush(int? id) //Красиво - меняется цвет текста взависимости от статуса
        {
            switch (id)
            {
                case 1: return Brushes.Gray; //Оформлен
                case 2: return Brushes.GreenYellow; //Готовится
                case 3: return Brushes.LightGreen; //Готов к выдаче
                case 4: return Brushes.DarkGreen; //Выполнен
                case 5: return Brushes.Red; // Отменен
            }
            return null;
        }
    }

    public class OrdersDisplayItems
    {
        public PizzaApp.Orders DbEntity { get; set; }
        public int Id { get; set; }
        public DateTime DateOrder { get; set; }
        public int TotalPrice { get; set; }
        public string Status { get; set; }
        public Brush StatBrush { get; set; }

    }
}
