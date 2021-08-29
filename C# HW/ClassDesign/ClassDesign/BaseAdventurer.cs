using System;
using System.Collections.Generic;
using System.Text;

namespace ClassDesign
{
    abstract class BaseAdventurer
    {
        public BaseAdventurer(){}
        public int Id { get; set; }
        public string Name { get; set; }
        public string Class { get; set; }
        public int Hp { get; set; }
        public int Mp { get; set; }

        public abstract void LogInfo();

        public void InputMessage()
        {
            Console.Write("Enter ID => ");
            Id = Convert.ToInt32(Console.ReadLine());
            Console.Write("Enter Name => ");
            Name = Console.ReadLine();
        }

        public void Print()
        {
            Console.WriteLine("\nAdventurer Created!");
            Console.WriteLine("Name: " + Name + "\nClass: " + Class + "\nHP: " + Hp + "\nMP: " + Mp);
        }
    }
    class Warrior : BaseAdventurer
    {
        public override void LogInfo()
        {
            InputMessage();
            Class = "Warrior";
            Hp = 10;
            Mp = 5;
            Print();
        }
    }
    class Archer : BaseAdventurer
    {
        public string ReasonNotToBuy { get; set; }

        public override void LogInfo()
        {
            InputMessage();
            Class = "Archer";
            Hp = 8;
            Mp = 8;
            Print();
        }
    }
    class Mage : BaseAdventurer
    {
        public override void LogInfo()
        {
            InputMessage();
            Class = "Mage";
            Hp = 5;
            Mp = 10;
            Print();
        }
    }
}
