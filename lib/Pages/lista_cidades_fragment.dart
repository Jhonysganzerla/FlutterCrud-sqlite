import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jhonyproject/Model/cidade.dart';
import 'package:jhonyproject/Pages/form_cidade_page.dart';
import 'package:jhonyproject/Services/cidade_services.dart';

class ListaCidadesFragment extends StatefulWidget {
  static const title = 'Cidades';

  const ListaCidadesFragment({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListaCidadesFragmentState();
}

class _ListaCidadesFragmentState extends State<ListaCidadesFragment> {
  final _service = CidadeService();

  final List<Cidade> _cidade = [];

  final _refreshIndicatorkey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshIndicatorkey.currentState?.show();
    });
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: LayoutBuilder(
        builder: (_, constraints) {
          Widget content;
          if (_cidade.isEmpty) {
            content = SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: const Center(
                  child: Text('Nenhuma cidade cadastrada'),
                ),
              ),
            );
          } else {
            content = ListView.separated(
                itemBuilder: (_, index) {
                  final cidade = _cidade[index];
                  return ListTile(
                    title: Text('${cidade.nome} - ${cidade.uf}'),
                    onTap: () => _mostrarDialogActions(cidade),
                  );
                },
                separatorBuilder: (_, __) => const Divider(),
                itemCount: _cidade.length);
          }
          return RefreshIndicator(
            key: _refreshIndicatorkey,
            child: content,
            onRefresh: _findCidades,
          );
        },
      ),
    );
  }

  Future<void> _findCidades() async {
    await Future.delayed(const Duration(seconds: 2));
    final cidades = await _service.findCidades();
    setState(() {
      _cidade.clear();
      if (cidades.isNotEmpty) {
        _cidade.addAll(cidades);
      }
    });
  }

  void _mostrarDialogActions(Cidade cidade) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${cidade.nome} - ${cidade.uf}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar'),
                onTap: () {
                  Navigator.pop(context);
                  _abrirForm(cidade: cidade);
                }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Excluir'),
              onTap: () {
                Navigator.pop(context);
                _excluirCidade(cidade: cidade);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'))
        ],
      ),
    );
  }

  void _abrirForm({Cidade? cidade}) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => FormCidadePage(cidade: cidade)))
        .then((changed) {
      if (changed) {
        _refreshIndicatorkey.currentState?.show();
      }
    });
  }

  void _excluirCidade({Cidade? cidade}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Atencao!!!!!!'),
        content: Text(
            'O Registro "${cidade!.nome} - ${cidade.uf}" será excluido, deseja continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                _service.deleteCidade(cidade).then(
                  (value) {
                    _refreshIndicatorkey.currentState?.show();
                  },
                ).catchError(
                  (erro, stacktrace) {
                    debugPrintStack(stackTrace: stacktrace);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Não foi possivel excluir o registro, tente novamente')));
                  },
                );
              },
              child: const Text('OK')),
        ],
      ),
    );
  }
}
