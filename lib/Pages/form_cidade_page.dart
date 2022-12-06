import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jhonyproject/Model/cidade.dart';
import 'package:jhonyproject/Services/cidade_services.dart';

class FormCidadePage extends StatefulWidget {
  final Cidade? cidade;

  const FormCidadePage({this.cidade});

  @override
  State<StatefulWidget> createState() => _FormCidadeState();
}

class _FormCidadeState extends State<FormCidadePage> {
  final _service = CidadeService();
  var _saving = false;
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  String? _currentUf;

  @override
  void initilState() {
    super.initState();
    if (widget.cidade != null) {
      _nomeController.text = widget.cidade!.nome;
      _currentUf = widget.cidade!.uf;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: null //_buildBody(),
        );
  }

  AppBar _buildAppBar() {
    final String title;
    if (widget.cidade == null) {
      title = 'Nova Cidade';
    } else {
      title = 'Alterar Cidade';
    }
    final Widget titleWidget;
    if (_saving) {
      titleWidget = Row(
        children: [
          Expanded(child: Text(title)),
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
        ],
      );
    } else {
      titleWidget = Text(title);
    }
    return AppBar(
      title: titleWidget,
      actions: [
        if (!_saving)
          IconButton(icon: Icon(Icons.check), onPressed: null //_save,
              ),
      ],
    );
  }

  Widget _buildBody() => Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.cidade!.codigo != null)
                  Text('Codigo: ${widget.cidade!.codigo}'),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nome',
                  ),
                  controller: _nomeController,
                  validator: (String? newValue) {
                    if (newValue == null || newValue.trim().isEmpty) {
                      return 'Informe o nome';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  value: _currentUf,
                  decoration: InputDecoration(
                    labelText: 'UF',
                  ),
                  items: _buildDropMenuItem(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _currentUf = newValue;
                    });
                  },
                  validator: (String? newValue) {
                    if (newValue == null || newValue.trim().isEmpty) {
                      return 'Informe a Uf';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      );

  List<DropdownMenuItem<String>> _buildDropMenuItem() {
    const ufs = ['RS', 'SC', 'PR'];
    final List<DropdownMenuItem<String>> items = [];
    for (final uf in ufs) {
      items.add(DropdownMenuItem(value: uf, child: Text(uf)));
    }
    return items;
  }

  Future<void> _save() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _saving = true;
    });

    try {
      await _service
          .saveCidade(Cidade(nome: _nomeController.text, uf: _currentUf!));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('nao deu boa')));
    }
    setState(() {
      _saving = false;
    });
  }
}
