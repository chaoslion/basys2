using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using AdeptCLR;

namespace epp_win {
    public partial class frmMain : Form {

        private EPP epp;
        private Byte cnt;
        private CheckBox[] boxes;

        public frmMain() {
            InitializeComponent();
        }

        private void frmMain_Load(object sender, EventArgs e) {
            this.boxes = new CheckBox[8]{
                this.cbValue0,
                this.cbValue1,
                this.cbValue2,
                this.cbValue3,
                this.cbValue4,
                this.cbValue5,
                this.cbValue6,
                this.cbValue7,
            };
            this.cnt = 0;
            this.epp = new EPP();
            this.epp.open("Basys2");
            this.epp.write(0x0, 0x0);
            this.timMain.Enabled = true;
        }

        private void frmMain_FormClosing(object sender, FormClosingEventArgs e) {
            this.epp.write(0x0, 0x0);
            this.epp.close();
        }

        private void timMain_Tick(object sender, EventArgs e) {

            this.tbValue.Text = this.cnt.ToString("X4");

            for(int i=7;i>=0;i--) {
                this.boxes[i].Checked = (this.cnt & (1 << i)) > 0;
            }

            this.epp.write(0x0, this.cnt++);
        }
    }
}
