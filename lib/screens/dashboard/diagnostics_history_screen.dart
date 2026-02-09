// Teşhis Geçmişi Ekranı
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/diagnostics_history_service.dart';
import '../../data/obd_codes.dart';

class DiagnosticsHistoryScreen extends StatefulWidget {
  const DiagnosticsHistoryScreen({super.key});

  @override
  State<DiagnosticsHistoryScreen> createState() =>
      _DiagnosticsHistoryScreenState();
}

class _DiagnosticsHistoryScreenState extends State<DiagnosticsHistoryScreen> {
  List<DiagnosticRecord> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);

    final history = await DiagnosticsHistoryService.getHistory();

    setState(() {
      _history = history;
      _isLoading = false;
    });
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Geçmişi Temizle',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'Tüm teşhis geçmişi silinecek. Bu işlem geri alınamaz.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Temizle'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DiagnosticsHistoryService.clearHistory();
      _loadHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Geçmiş temizlendi'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _deleteRecord(String id) async {
    await DiagnosticsHistoryService.deleteRecord(id);
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0A0A15) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.transparent : Colors.white,
        elevation: isDark ? 0 : 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'TEŞHİS GEÇMİŞİ',
          style: TextStyle(
              letterSpacing: 2, color: isDark ? Colors.white : Colors.black87),
        ),
        centerTitle: true,
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep, color: Colors.red[400]),
              onPressed: _clearHistory,
              tooltip: 'Geçmişi Temizle',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? _buildEmptyState(isDark)
              : _buildHistoryList(isDark),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: isDark ? Colors.grey[700] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz teşhis kaydı yok',
            style: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey[600],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'OBD teşhisi yaptığınızda\nkayıtlar burada görünecek',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.grey[600] : Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(bool isDark) {
    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final record = _history[index];
          return _buildHistoryCard(record, isDark);
        },
      ),
    );
  }

  Widget _buildHistoryCard(DiagnosticRecord record, bool isDark) {
    final statusColor = _getStatusColor(record.status);
    final statusIcon = _getStatusIcon(record.status);
    final statusText = _getStatusText(record.status);

    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _deleteRecord(record.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: statusColor.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _showRecordDetails(record, isDark),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık satırı
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(statusIcon, color: statusColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.vehicleName,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatDate(record.timestamp),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // DTC Kodları
                  if (record.dtcCodes.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: record.dtcCodes.take(5).map((code) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Colors.red.withOpacity(0.5)),
                          ),
                          child: Text(
                            code,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    if (record.dtcCodes.length > 5)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '+${record.dtcCodes.length - 5} daha fazla kod',
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ),
                  ],

                  // Canlı veri özeti
                  if (record.liveData.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: record.liveData.entries.take(3).map((entry) {
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  entry.value,
                                  style: TextStyle(
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  entry.key,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showRecordDetails(DiagnosticRecord record, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(record.status),
                    color: _getStatusColor(record.status),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.vehicleName,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatDateFull(record.timestamp),
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.grey,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DTC Kodları
                    Text(
                      'ARIZA KODLARI',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (record.dtcCodes.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 12),
                            Text(
                              'Arıza kodu bulunamadı',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...record.dtcCodes.map((code) {
                        final obdCode = obdCodes.firstWhere(
                          (c) => c.code == code,
                          orElse: () => OBDCode(
                            code: code,
                            description: 'Bilinmeyen arıza kodu',
                            category: 'Genel',
                            severity: 'medium',
                            possibleCauses: [],
                          ),
                        );
                        final description = obdCode.description;
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                code,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                description,
                                style: TextStyle(
                                  color:
                                      isDark ? Colors.white70 : Colors.black87,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                    const SizedBox(height: 24),

                    // Canlı Veriler
                    if (record.liveData.isNotEmpty) ...[
                      Text(
                        'CANLI VERİLER',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 2.5,
                        children: record.liveData.entries.map((entry) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  entry.value,
                                  style: TextStyle(
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    // Notlar
                    if (record.notes != null && record.notes!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'NOTLAR',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          record.notes!,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(DiagnosticStatus status) {
    switch (status) {
      case DiagnosticStatus.healthy:
        return Colors.green;
      case DiagnosticStatus.hasErrors:
        return Colors.red;
      case DiagnosticStatus.pending:
        return Colors.orange;
      case DiagnosticStatus.unknown:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(DiagnosticStatus status) {
    switch (status) {
      case DiagnosticStatus.healthy:
        return Icons.check_circle;
      case DiagnosticStatus.hasErrors:
        return Icons.error;
      case DiagnosticStatus.pending:
        return Icons.hourglass_empty;
      case DiagnosticStatus.unknown:
        return Icons.help;
    }
  }

  String _getStatusText(DiagnosticStatus status) {
    switch (status) {
      case DiagnosticStatus.healthy:
        return 'TEMİZ';
      case DiagnosticStatus.hasErrors:
        return 'ARIZA';
      case DiagnosticStatus.pending:
        return 'BEKLEMEDE';
      case DiagnosticStatus.unknown:
        return 'BİLİNMİYOR';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} dakika önce';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} saat önce';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatDateFull(DateTime date) {
    final days = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar'
    ];
    final months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];

    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year} - '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
