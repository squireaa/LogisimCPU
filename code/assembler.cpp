#ifndef __PROJECT1_CPP__
#define __PROJECT1_CPP__

#include "project1.h"
#include <vector>
#include <string>
#include <map>
#include <iostream>
#include <sstream>
#include <fstream>
#include <algorithm>

int encode_addi_lw_sw(int, int, int, int);
int encode_jumps(int, int);
int encode_jr(int, int, int, int);

int main(int argc, char* argv[]) {
    if (argc < 4) // Checks that at least 3 arguments are given in command line
    {
        std::cerr << "Expected Usage:\n ./assemble infile1.asm infile2.asm ... infilek.asm staticmem_outfile.bin instructions_outfile.bin\n" << std::endl;
        exit(1);
    }
    //Prepare output files
    std::ofstream inst_outfile, static_outfile;
    static_outfile.open(argv[argc - 2], std::ios::binary);
    inst_outfile.open(argv[argc - 1], std::ios::binary);
    std::vector<std::string> instructions;

    // list of all the instructions to determine if a line is an instruction or a label
    std::vector<std::string> instruction_keywords {
        "add", "sub", "addi", "mult", "div", "mflo", "mfhi", "sll",
        "srl", "lw", "sw", "slt", "beq", "bne", "j", "jal", "jr", "jalr", "syscall", "la", 
        "and", "or", "nor", "xor", "andi", "ori", "xori"
    };

    // list of all the .labels to differentiate things like ".globl" and a real label
    std::vector<std::string> dot_labels {
        ".globl", ".data", ".text"
    };

    // maps line numbers to the instructions, and maps labels to the line they point to
    std::map<int, std::vector<std::string>> instruction_numbers;
    std::unordered_map<std::string, int> label_numbers;

    //For each input file:
    for (int i = 1; i < argc - 2; i++) {
        std::ifstream infile(argv[i]); //  open the input file for reading
        if (!infile) { // if file can't be opened, need to let the user know
            std::cerr << "Error: could not open file: " << argv[i] << std::endl;
            exit(1);
        }

        std::string str;
        while (getline(infile, str)){ //Read a line from the file
            str = clean(str); // remove comments, leading and trailing whitespace
            if (str == "") { //Ignore empty lines
                continue;
            }
            instructions.push_back(str); // TODO This will need to change for labels
        }
        infile.close();
    }

    // map the instructions to their line numbers, and the labels to the line they point to
    int counter = 0;
    for (std::string inst : instructions) {
        std::vector<std::string> terms = split(inst, WHITESPACE+",()");
        std::string inst_type = terms[0];

        // adds instructions to instruction_numbers, and labels to label_numbers
        if (std::count(instruction_keywords.begin(), instruction_keywords.end(), inst_type)) {
            instruction_numbers.insert({counter, terms});
            counter++;
        } else if (!std::count(dot_labels.begin(), dot_labels.end(), inst_type)) {
            std::string label = inst_type.substr(0, inst_type.length() - 1);
            label_numbers.insert({label, counter});
        }
    }

    int begin = 0; // tells us where the string begins
    // defines the map of labels and the memory they point to, and the vector to hold all static memory
    std::unordered_map<std::string, int> static_label_numbers;
    std::vector<int> static_memory;

    // creates a switch so between .data and .text, static memory is read
    bool static_mem_switch = false;
    int memory_position = 0;

    // reads the static memory and fills in the map and the static memory vector
    for (std::string inst : instructions) {
        if (inst == ".text") {
            static_mem_switch = false;
            continue;
        } else if (static_mem_switch) {
            std::vector<std::string> terms = split(inst, WHITESPACE+",()");
            std::string label = terms[0]; // static memory label
            label = label.substr(0, label.length() - 1); // gets rid of the colon

            static_label_numbers.insert({label, memory_position}); // adds the label and the mem_pos to the map
            if (terms[1] == ".word") {
                for (int i = 2; i < terms.size(); i++) { // i is going from the beginning 
                    try {
                        static_memory.push_back(stoi(terms[i]));
                    } catch (...) {
                        static_memory.push_back(label_numbers[terms[i]] * 4);
                    }
                }
                memory_position += ((terms.size() - 2) * 4);
            } else if (terms[1] == ".asciiz") { // storing strings in memory
                for (int i = 0; i < inst.size(); i++) { // i is going from the beginning 
                    if (inst[i] == '"') {
                        begin = i;
                    } else if(i > begin && begin != 0) {
                            static_memory.push_back((int)inst[i]);
                            memory_position += 4;
                    }
                }
                static_memory.push_back(0);
                memory_position += 4;
            }
        } else if (inst == ".data") {
            static_mem_switch = true;
            continue;
        }
    }

    // write the _END_OF_STATIC_MEMORY_ label
    static_label_numbers.insert({"_END_OF_STATIC_MEMORY_", memory_position});

    // writes the static memory to the static outfile
    for (int n : static_memory) {
        write_binary(n, static_outfile);
    }

    // starts the problem at main (if there's no main it starts at 0 which is also right)
    //int line_on = label_numbers["main"];
    int line_on = 0;

    // encodes each instruction depending on the instruction
    for (auto i = instruction_numbers.begin(); i != instruction_numbers.end(); i++) {
        std::vector<std::string> terms = i->second;
        std::string inst_type = terms[0];
        if (inst_type == "add") {
            write_binary(encode_Rtype(0,registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 32),inst_outfile);
        } else if (inst_type == "sub") {
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 34), inst_outfile);
        } else if (inst_type == "addi") {
            write_binary(encode_addi_lw_sw(8, registers[terms[2]], registers[terms[1]], stoi(terms[3])), inst_outfile);
        } else if (inst_type == "mfhi") {
            write_binary(encode_Rtype(0, 0, 0, registers[terms[1]], 0, 16), inst_outfile);
        } else if (inst_type == "mflo") {
            write_binary(encode_Rtype(0, 0, 0, registers[terms[1]], 0, 18), inst_outfile);;
        } else if (inst_type == "mult") {
            write_binary(encode_Rtype(0, registers[terms[1]], registers[terms[2]], 0, 0, 24), inst_outfile);
        } else if (inst_type == "div") {
            write_binary(encode_Rtype(0, registers[terms[1]], registers[terms[2]], 0, 0, 26), inst_outfile);
        } else if (inst_type == "lw") {
            write_binary(encode_addi_lw_sw(35, registers[terms[3]], registers[terms[1]], stoi(terms[2])), inst_outfile); 
        } else if (inst_type == "sw") {
            write_binary(encode_addi_lw_sw(43, registers[terms[3]], registers[terms[1]], stoi(terms[2])), inst_outfile);
        } else if (inst_type == "slt") {
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 42), inst_outfile);
        } else if (inst_type == "syscall") {
            write_binary(encode_Rtype(0, 0, 0, 26, 0, 12), inst_outfile);
        } else if (inst_type == "sll") {
            write_binary(encode_Rtype(0, 0, registers[terms[2]], registers[terms[1]], stoi(terms[3]), 0), inst_outfile);
        } else if (inst_type == "srl") {
            write_binary(encode_Rtype(0, 0, registers[terms[2]], registers[terms[1]], stoi(terms[3]), 2), inst_outfile);
        } else if (inst_type == "beq") {
            int label_line = label_numbers[terms[3]];
            int offset = -(line_on + 1 - label_line);
            write_binary(encode_addi_lw_sw(4, registers[terms[1]], registers[terms[2]], offset), inst_outfile);
        } else if (inst_type == "bne") {
            int label_line = label_numbers[terms[3]];
            int offset = -(line_on + 1 - label_line);
            write_binary(encode_addi_lw_sw(5, registers[terms[1]], registers[terms[2]], offset), inst_outfile);
        } else if (inst_type == "jal") {
            int target = label_numbers[terms[1]];
            write_binary(encode_jumps(3, target), inst_outfile);
        } else if (inst_type == "j") {
            int target = label_numbers[terms[1]];
            write_binary(encode_jumps(2, target), inst_outfile);
        } else if (inst_type == "jr") {
            write_binary(encode_jr(0, registers[terms[1]], 0, 8), inst_outfile);
        } else if (inst_type == "jalr") {
            if (terms.size() == 2) {
                write_binary(encode_Rtype(0, registers[terms[1]], 0, 31, 0, 9), inst_outfile);
            } else {
                write_binary(encode_Rtype(0, registers[terms[1]], 0, registers[terms[2]], 0, 9), inst_outfile);
            }
        } else if (inst_type == "la") {
            int static_address = static_label_numbers[terms[2]];
            write_binary(encode_addi_lw_sw(8, registers[terms[2]], registers[terms[1]], static_address), inst_outfile);
        } else if (inst_type == "and") {
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 36), inst_outfile);
        } else if (inst_type == "or") {
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 37), inst_outfile);
        } else if (inst_type == "xor") {
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 38), inst_outfile);
        } else if (inst_type == "nor") {
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 39), inst_outfile);
        } else if (inst_type == "andi") {
            write_binary(encode_addi_lw_sw(12, registers[terms[2]], registers[terms[1]], stoi(terms[3])), inst_outfile);
        } else if (inst_type == "ori") {
            write_binary(encode_addi_lw_sw(13, registers[terms[2]], registers[terms[1]], stoi(terms[3])), inst_outfile);
        } else if (inst_type == "xori") {
            write_binary(encode_addi_lw_sw(14, registers[terms[2]], registers[terms[1]], stoi(terms[3])), inst_outfile);
        }
        line_on++;
    }
}

// function for encoding addi, lw, and sw
int encode_addi_lw_sw(int opcode, int rs, int rt, int n) { // ask about if lw sw can be more than immediate of addi
    if (n < 0) {
        return ((opcode << 26) + (rs << 21) + (rt << 16) + 65535) & n;
    }
    return (opcode << 26) + (rs << 21) + (rt << 16) + n;
}

// function for encoding j, and jal
int encode_jumps(int opcode, int target) {
    return (opcode << 26) + target;
}

// function for encoding jr
int encode_jr(int opcode, int rs, int zeros, int funccode) {
    return (opcode << 26) + (rs << 21) + (zeros << 6) + funccode;
}


#endif