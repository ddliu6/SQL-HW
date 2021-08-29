using System;
using System.Collections.Generic;
using System.Text;

namespace ClassDesign
{
    class AdventurerFactory
    {
        public BaseAdventurer GetObject(string choice)
        {
            AdventurerOptions op;
            Enum.TryParse<AdventurerOptions>(choice, out op);
            switch (op)
            {
                case AdventurerOptions.Warrior:
                    return new Warrior();
                case AdventurerOptions.Archer:
                    return new Archer();
                case AdventurerOptions.Mage:
                    return new Mage();
            }
            return null;
        }
    }
}
