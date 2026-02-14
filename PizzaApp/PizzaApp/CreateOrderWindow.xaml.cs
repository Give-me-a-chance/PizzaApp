using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
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

namespace PizzaApp
{
    /// <summary>
    /// Логика взаимодействия для CreateOrderWindow.xaml
    /// </summary>
    public partial class CreateOrderWindow : Window //Создание заказа со стороны работника
    {
        private PizzaTestEntities _entities = new PizzaTestEntities();
        public ObservableCollection<OrderItemDraft> DraftItems { get; set; } = new ObservableCollection<OrderItemDraft>();
        public CreateOrderWindow()
        {
            InitializeComponent();
            ProductsCb.ItemsSource = _entities.Products.ToList();
            OrderItemsGrid.ItemsSource = DraftItems;
        }

        private void AddProduct_Click(object sender, RoutedEventArgs e)
        {

            if (ProductsCb.SelectedItem is Products product)
            {
                var existing = DraftItems.FirstOrDefault(x => x.Product.id == product.id);

                if (existing != null)
                {
                    existing.Quantity++;
                }
                else
                {
                    DraftItems.Add(new OrderItemDraft
                    {
                        Product = product,
                        Quantity = 1
                    });
                }

             //   UpdateTotal();
            }

        }

       

        private void FinishOrder_Click(object sender, RoutedEventArgs e)
        {

            if (!DraftItems.Any())
            {
                MessageBox.Show("Заказ пуст");
                return;
            }

            if (NameTb.Text == "" && EmailTb.Text == "")
            {
                MessageBox.Show("Необходимо Имя или почта пользователя");
                return;
            }    
            var user = ResolveUser(); // логика email / имени

            if (user == null) 
            {
                MessageBox.Show("Пользователь с такой почтой не найден");
                return;
            }

            var order = new Orders
            {
                id_user = user.id,
                dateorder = DateTime.Now,
                stat = 1,
                total = (int?)DraftItems.Sum(x => x.Total)
            };

            _entities.Orders.Add(order);
            _entities.SaveChanges();

            foreach (var item in DraftItems)
            {
                _entities.OrderItem.Add(new OrderItem
                {
                    id_zak = order.id,
                    id_tov = item.Product.id,
                    count = item.Quantity,
                });
            }

            _entities.SaveChanges();
            Close();
        }

        private Users ResolveUser()
        {
            if (EmailTb.Text == "") //В случае, если пользователь не зарегистрирован - создается новая строка в БД, где mail = null.
                                    //(сохраняется только имя - для отображения на табло)
                                    //Ограничения для mail - unique, но позволяет создавать несколько строк с null значением
            {
                var resolve = _entities.Users.Add(new Users
                {
                    role = 1,
                    name = NameTb.Text
                });
                _entities.SaveChanges();
                return resolve;
            }
            else // Если пользователь зарегистрирован, то привязываем к нему (по почте)
            {
                Users resolve = _entities.Users.FirstOrDefault(u => u.mail == EmailTb.Text);  
                return resolve;
            }
        }


    }

    public class OrderItemDraft : INotifyPropertyChanged
    {
        public Products Product { get; set; }

        public string Name => Product.name;
        public int Price => (int)Product.price;

        private int _quantity = 1;
        public int Quantity
        {
            get => _quantity;
            set
            {
                if (_quantity != value)
                {
                    _quantity = value;
                    OnPropertyChanged(nameof(Quantity));
                    OnPropertyChanged(nameof(Total));
                }
            }
        }

        public decimal Total => Price * Quantity;

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string prop)
            => PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(prop));
    }

}
