import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Armazena os votos de cada candidato em um mapa global
Map<String, Map<String, int>> votosCandidatos = {};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserScreen()),
                );
              },
              child: const Text('Cadastrar'),
            ),
            const SizedBox(height: 20), // Espaço entre os botões
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConsultarScreen()),
                );
              },
              child: const Text('Consultar'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _controller = TextEditingController();
  String _inputValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID usuário',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _inputValue = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_inputValue.isNotEmpty && int.tryParse(_inputValue) != null && int.parse(_inputValue) > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CadastrarScreen()),
                    );
                    print(_inputValue);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, insira um ID válido.')),
                    );
                  }
                },
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CadastrarScreen extends StatefulWidget {
  const CadastrarScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CadastrarScreenState createState() => _CadastrarScreenState();
}

class _CadastrarScreenState extends State<CadastrarScreen> {
  final TextEditingController _votosBrancosController = TextEditingController();
  final TextEditingController _votosNulosController = TextEditingController();
  final TextEditingController _votosValidosController = TextEditingController();
  
  String? _selectedCandidate;
  final List<String> _candidates = ['Candidato A', 'Candidato B', 'Candidato C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lançamento de Votos'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Campo para Votos Brancos
              TextField(
                controller: _votosBrancosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Votos Brancos',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              
              // Campo para Votos Nulos
              TextField(
                controller: _votosNulosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Votos Nulos',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Campo para Votos Válidos
              TextField(
                controller: _votosValidosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Votos Válidos',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Dropdown para selecionar candidato
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Selecione um candidato',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCandidate,
                items: _candidates.map((String candidate) {
                  return DropdownMenuItem<String>(
                    value: candidate,
                    child: Text(candidate),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCandidate = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Botão Enviar
              ElevatedButton(
                onPressed: () {
                  if (_selectedCandidate != null && 
                      _votosBrancosController.text.isNotEmpty &&
                      _votosNulosController.text.isNotEmpty &&
                      _votosValidosController.text.isNotEmpty) {
                    
                    // Converte as entradas para inteiros
                    int votosBrancos = int.parse(_votosBrancosController.text);
                    int votosNulos = int.parse(_votosNulosController.text);
                    int votosValidos = int.parse(_votosValidosController.text);

                    // Armazena os dados no mapa global
                    votosCandidatos[_selectedCandidate!] = {
                      'Brancos': votosBrancos,
                      'Nulos': votosNulos,
                      'Válidos': votosValidos,
                    };

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Votos enviados com sucesso!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, preencha todos os campos.')),
                    );
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ConsultarScreen extends StatefulWidget {
  const ConsultarScreen({super.key});

  @override
  _ConsultarScreenState createState() => _ConsultarScreenState();
}

class _ConsultarScreenState extends State<ConsultarScreen> {
  String? _selectedCandidate;
  final List<String> _candidates = ['Candidato A', 'Candidato B', 'Candidato C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar Votos'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Dropdown para selecionar o candidato
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Selecione um candidato',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCandidate,
                items: _candidates.map((String candidate) {
                  return DropdownMenuItem<String>(
                    value: candidate,
                    child: Text(candidate),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCandidate = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Exibição das informações de votos
              if (_selectedCandidate != null && votosCandidatos.containsKey(_selectedCandidate!))
                Column(
                  children: [
                    Text('Votos Brancos: ${votosCandidatos[_selectedCandidate]!['Brancos']}'),
                    Text('Votos Nulos: ${votosCandidatos[_selectedCandidate]!['Nulos']}'),
                    Text('Não Nulos: ${votosCandidatos[_selectedCandidate]!['Válidos']}'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
