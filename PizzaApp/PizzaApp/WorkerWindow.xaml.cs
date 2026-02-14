using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.Entity;
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
using System.Windows.Shapes;
using System.Windows.Threading;

namespace PizzaApp
{
    /// <summary>
    /// Логика взаимодействия для WorkerWindow.xaml
    /// </summary>
    public partial class WorkerWindow : Window
    {
        public PizzaTestEntities _entities = new PizzaTestEntities();
        public ObservableCollection<ActiveOrders> _orders = new ObservableCollection<ActiveOrders>();
        //  public static event EventHandler WindowChanged;

        private DispatcherTimer _timer;
        public WorkerWindow()
        {
            InitializeComponent();
            LoadData();

            _timer = new DispatcherTimer            
            {
                Interval = TimeSpan.FromSeconds(5)
            };
            _timer.Tick += (s, e) => LoadData();
            _timer.Start();
        }

        public void LoadData()
        {

            _orders.Clear();
            OrdersControl.ItemsSource = null;

            var statuses = _entities.Statuses
                .Select(s => new StatusItem
                {
                    Id = s.id,
                    Name = s.descr
                }).ToList();

            var dbitems = _entities.Orders.Where(o => o.stat < 4).ToList();

            foreach (var item in dbitems)
            {
                _orders.Add(new ActiveOrders
                {
                    Id = item.id,
                    Name = item.Users.name,
                    Statuses = statuses,
                    SelectedStatus = statuses.First(s => s.Id == item.stat),

                    ProductsOrder = item.OrderItem.Select(oi => oi.Products.name + " x" + oi.count).ToList()
                });
            }

           
            OrdersControl.ItemsSource = _orders;

        }
        public Brush SetBrush(int? id)
        {
            switch (id)
            {
                case 1: return Brushes.Gray;
                case 2: return Brushes.GreenYellow;
                case 3: return Brushes.LightGreen;
                case 4: return Brushes.DarkGreen;
                case 5: return Brushes.Red;
            }
            return null;
        }

        private void StatusChanged(object sender, SelectionChangedEventArgs e)  //Меняем статус с помощью combobox
        {
            if (sender is ComboBox cb && cb.DataContext is ActiveOrders order)
            {
                var dbOrder = _entities.Orders.First(o => o.id == order.Id);
                dbOrder.stat = order.SelectedStatus.Id;
                _entities.SaveChanges();
                LoadData();
              //  WindowChanged?.Invoke(this, EventArgs.Empty);
            }
            
        }

        private void CreateBt_Click(object sender, RoutedEventArgs e)
        {
            CreateOrderWindow window = new CreateOrderWindow(); //Создание заказа - в случае если пользователь физически подошел к работнику (кассиру)
            window.ShowDialog();
           // window.Owner = this;
            
        }

        private void DisplayTb_Click(object sender, RoutedEventArgs e)
        {
            DisplayWindow display = new DisplayWindow(); //Открываем табло из этого окна
            display.Show();
        }
    }

    public class ActiveOrders
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public List<StatusItem> Statuses { get; set; }
        public StatusItem SelectedStatus { get; set; }
        public List<String> ProductsOrder { get; set; }
    }

    public class StatusItem
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public Brush BrushStatus { get; set; }
    }


}
