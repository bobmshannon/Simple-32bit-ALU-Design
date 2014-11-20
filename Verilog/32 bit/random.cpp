/**
	This program is a quick and dirty wrapper for a verilog executable.
	It provides 5000 random input patterns using boost::random and writes the 
	output to abort text file so that analysis can be performed later.
*/

#include <iostream>
#include <stdio.h>
#include <string>
#include <cstring>
#include <bitset>
#include <boost/random/mersenne_twister.hpp>
#include <boost/random/uniform_int_distribution.hpp>
#include <boost/algorithm/string.hpp>
#include <vector>
#include <fstream>
#include <iterator>

using namespace std;
using namespace boost::algorithm;

boost::random::mt19937 gen;

string exec(string str) {
	const char* cmd = str.c_str();
    FILE* pipe = popen(cmd, "r");
    if (!pipe) return "ERROR";
    char buffer[128];
    string result = "";
    while(!feof(pipe)) {
    	if(fgets(buffer, 128, pipe) != NULL)
    		result += buffer;
    }
    pclose(pipe);
    return result;
}

void add(string delay, string opcode, vector<pair<string,string> >& db) {
	db.push_back(make_pair(delay,opcode));
}

int main() {
	string x, y, opcode;
	string cmd;

    boost::random::uniform_int_distribution<> dist32bit(0, 2147483647);
	boost::random::uniform_int_distribution<> dist3bit(0, 4);
	
	vector<pair<string,string> > db;
	
	for(int i = 0; i < 5000; i++) {
		gen.seed(static_cast<unsigned int>(time(0) + getpid()) + i);
		
		int r0 = dist32bit(gen);
		int r1 = dist32bit(gen); 
		int r2 = dist3bit(gen);
		
		//cout << r0 << " " << r1 << " " << r2 << endl;
		
		bitset<32> t0(r0);
		bitset<32> t1(r1);
		bitset<3> t2(r2);
		x = t0.to_string();
		y = t1.to_string();
		opcode = t2.to_string();
		
		//cout << x << " " << y << " " << opcode << endl;
		
		cmd = "vvp a.out +x=" + x + " +y=" + y + " +opcode=" + opcode;
		string out = exec(cmd);
		
		//cout << out;
		
		int index;
		string delay;
		const char* process = out.c_str();
		
		for(int i = strlen(process) - 1; i >= 0; i--) {
			if(process[i] == ' ') { index = i; break; }
		}
		
		for(int i = index + 1; i < strlen(process); i++) {
			delay = delay + process[i];
		}
		
		add(delay, opcode, db);
		
		cout << i << endl;
	}
	
	int j;
	ofstream f("5krandominputs.txt");
	for(vector<pair<string,string> >::const_iterator i = db.begin(); i != db.end(); ++i) {
		string first = (*i).first;
		string second = (*i).second;
		trim(first);
		trim(second);
		string w = first + " " + second + '\n';
		f << w;
		int j;
		cout << "writing..." << j++ << endl;
	}
}